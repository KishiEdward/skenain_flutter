import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/services/secure_storage.dart';

// 5.1 Representasi kondisi autentikasi
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailNotVerified,
  error,
}

// 5.2 AuthProvider Base
class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // State Internal
  AuthStatus _status = AuthStatus.initial;
  User? _firebaseUser;
  String? _backendToken; 
  String? _errorMessage;

  String? _tempEmail;
  String? _tempPassword;

  // Getters (Untuk dibaca oleh UI)
  AuthStatus get status => _status;
  String? get backendToken => _backendToken;
  User? get firebaseUser => _firebaseUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;
}