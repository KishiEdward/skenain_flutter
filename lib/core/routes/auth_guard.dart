import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';

class AuthGuard extends StatelessWidget {
  const AuthGuard({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau status login dari AuthProvider
    final authStatus = context.watch<AuthProvider>().status;

    // Logika Route Guard (Satpam Aplikasi)
    return switch (authStatus) {
      // Jika statusnya berhasil login & terverifikasi Masuk ke Dashboard
      AuthStatus.authenticated => const DashboardPage(),

      // Jika login tapi email belum di-klik Masuk ke halaman Verifikasi
      AuthStatus.emailNotVerified => const VerifyEmailPage(),

      // Jika sedang loading dari memori saat aplikasi baru buka dan tampilkan Loading
      AuthStatus.initial => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF5D4037)),
        ),
      ),

      // Jika statusnya unauthenticated atau error lempar ke Login
      _ => const LoginPage(),
    };
  }
}
