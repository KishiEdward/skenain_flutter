import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_button.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? _timer;
  bool _resendCooldown = false;
  int _countdown = 60;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Polling: cek setiap 5 detik apakah email sudah diverifikasi
  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!mounted) return;
      
      final auth = context.read<AuthProvider>();
      final success = await auth.checkEmailVerified();
      
      if (success && mounted) {
        _timer?.cancel();
        // Jika berhasil terverifikasi, otomatis lempar ke Dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });
  }

  Future<void> _resendEmail() async {
    if (_resendCooldown) return;
    
    await context.read<AuthProvider>().resendVerificationEmail();
    
    // Aktifkan Cooldown 60 detik sebelum bisa kirim lagi
    setState(() {
      _resendCooldown = true;
      _countdown = 60;
    });
    
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_countdown <= 0) {
          _resendCooldown = false;
          t.cancel();
        } else {
          _countdown--;
        }
      });
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verifikasi sudah dikirim ulang')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data user dari provider untuk menampilkan emailnya
    final user = context.watch<AuthProvider>().firebaseUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Widget Reusable: AuthHeader
              const AuthHeader(
                icon: Icons.mark_email_unread_outlined,
                title: 'Verifikasi Email Kamu',
                subtitle: 'Kami sudah mengirim link verifikasi ke email di bawah ini.',
                iconColor: Color(0xFFC0A080), // Warna Khaki / Krem Tua (Tema Earth Tone)
              ),
              const SizedBox(height: 24),
              
              // Tampilkan email user
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  user?.email ?? '-',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 32),
              
              // Indikator polling (Animasi Loading kecil)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Menunggu konfirmasi...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Tombol kirim ulang dengan cooldown (Menggunakan OutlinedButton standar)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _resendCooldown ? null : _resendEmail,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF5D4037)), // Warna Coklat Utama
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _resendCooldown
                        ? 'Kirim Ulang ($_countdown detik)'
                        : 'Kirim Ulang Email',
                    style: TextStyle(
                      color: _resendCooldown ? Colors.grey : const Color(0xFF5D4037),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Tombol Ganti Akun / Logout (Menggunakan TextButton standar)
              TextButton(
                onPressed: () {
                  context.read<AuthProvider>().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  'Ganti Akun / Logout',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}