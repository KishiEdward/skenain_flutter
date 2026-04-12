import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_overlay.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Menyiapkan "kunci" dan pengontrol teks untuk form
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  
  bool _showPass = false;

  // Jangan lupa membuang controller dari memori saat halaman ditutup
  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Logika pendaftaran akan kita tambahkan di Commit 4
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 32),
                
                // Widget Reusable: Header (Selesai di Commit 1)
                const AuthHeader(
                  icon: Icons.person_add_alt_1,
                  title: 'Buat Akun Baru',
                  subtitle: 'Lengkapi data diri Anda untuk mendaftar',
                ),
                const SizedBox(height: 32),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}