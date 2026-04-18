import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/services/secure_storage.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailNotVerified,
  error,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_CLIENT_ID'] ?? '',
  );

  // State Internal
  AuthStatus _status = AuthStatus.initial;
  User? _firebaseUser;
  String? _backendToken;
  String? _errorMessage;

  String? _tempEmail;
  String? _tempPassword;

  AuthProvider() {
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    _firebaseUser = _auth.currentUser;

    if (_firebaseUser == null) {
      // Jika tidak ada user yang login, arahkan ke halaman Login
      _status = AuthStatus.unauthenticated;
    } else if (!(_firebaseUser!.emailVerified)) {
      // Jika login tapi email belum diverifikasi
      _status = AuthStatus.emailNotVerified;
    } else {
      // Jika sudah login dan aman
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  // Getters (Untuk dibaca oleh UI)
  AuthStatus get status => _status;
  String? get backendToken => _backendToken;
  User? get firebaseUser => _firebaseUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  // Alur register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = credential.user;

      await _firebaseUser?.updateDisplayName(name);
      await _firebaseUser?.sendEmailVerification();

      _tempEmail = email;
      _tempPassword = password;

      _status = AuthStatus.emailNotVerified;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan: $e');
      return false;
    }
  }

  // alur konfirasi email setelah register
  Future<bool> loginAfterEmailVerification() async {
    _setLoading();
    try {
      // Refresh status user dari server Firebase
      await _firebaseUser?.reload();
      _firebaseUser = _auth.currentUser;

      // Jika ternyata masih belum diverifikasi
      if (!(_firebaseUser?.emailVerified ?? false)) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return false;
      }

      // Re-login otomatis menggunakan data sementara untuk dapat fresh session & token
      if (_tempEmail != null && _tempPassword != null) {
        final credential = await _auth.signInWithEmailAndPassword(
          email: _tempEmail!,
          password: _tempPassword!,
        );
        _firebaseUser = credential.user;
        _tempEmail = null;
        _tempPassword = null;
      }

      // Lanjut tukar token ke Golang
      return await _verifyTokenToBackend();
    } catch (e) {
      _setError('Gagal sinkronisasi data: $e');
      return false;
    }
  }

  // alur verify token
  Future<bool> _verifyTokenToBackend() async {
    try {
      // Ambil ID Token dari Firebase (yang umurnya cuma 1 jam)
      final firebaseToken = await _firebaseUser?.getIdToken(true);

      // POST token tersebut ke backend Golang kamu lewat DioClient
      final response = await DioClient.instance.post(
        ApiConstants.verifyToken,
        data: {'firebase_token': firebaseToken},
      );

      // Ambil Access Token (JWT) balasan dari Golang
      final data = response.data['data'] as Map<String, dynamic>;
      _backendToken = data['access_token'] as String;

      // Simpan aman di Brankas (Secure Storage) HP pengguna
      await SecureStorageService.saveToken(_backendToken!);

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(
        'Gagal verifikasi di server backend. Pastikan server Golang menyala.',
      );
      return false;
    }
  }

  // Login dengan email
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = credential.user;

      if (!(_firebaseUser?.emailVerified ?? false)) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return false;
      }

      return await _verifyTokenToBackend();
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan: $e');
      return false;
    }
  }

  // Login dengan google
  Future<bool> loginWithGoogle() async {
    _setLoading();
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setError('Login Google dibatalkan');
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      _firebaseUser = userCred.user;

      // Google login, email otomatis terverifikasi
      return await _verifyTokenToBackend();
    } catch (e) {
      _setError('Gagal login dengan Google: $e');
      return false;
    }
  }

  // Resend email verifikasi
  Future<void> resendVerificationEmail() async {
    await _firebaseUser?.sendEmailVerification();
  }

  Future<bool> checkEmailVerified() async {
    await _firebaseUser?.reload();
    _firebaseUser = _auth.currentUser;

    if (_firebaseUser?.emailVerified ?? false) {
      return await _verifyTokenToBackend();
    }
    return false;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await SecureStorageService.clearAll();

    _firebaseUser = null;
    _backendToken = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // Private helper
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  String _mapFirebaseError(String code) => switch (code) {
    'email-already-in-use' => 'Email sudah terdaftar. Gunakan email lain.',
    'user-not-found' => 'Akun tidak ditemukan. Silakan daftar.',
    'wrong-password' => 'Password salah. Coba lagi.',
    'invalid-email' => 'Format email tidak valid.',
    'weak-password' => 'Password terlalu lemah. Minimal 6 karakter.',
    'invalid-credential' => 'Kredensial tidak valid atau salah.',
    'network-request-failed' => 'Tidak ada koneksi internet.',
    _ => 'Terjadi kesalahan ($code). Coba lagi.',
  };
}
