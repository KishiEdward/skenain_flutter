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
    // Validasi form sebelum mengirim ke provider
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      // Navigasi ke halaman instruksi verifikasi email
      Navigator.pushReplacementNamed(context, '/verify-email');
    } else {
      // Munculkan pesan error dari provider (warna merah bata earth tone)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Pendaftaran gagal'),
          backgroundColor: const Color(0xFFB3261E), 
        ),
      );
    }
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
                
                // Form Nama
                  CustomTextField(
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama lengkap',
                    controller: _nameCtrl,
                    validator: (v) => (v?.isEmpty ?? true) ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Form Email
                  CustomTextField(
                    label: 'Email',
                    hint: 'contoh@email.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v?.isEmpty ?? true) return 'Email wajib diisi';
                      if (!EmailValidator.validate(v!)) return 'Format email salah';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Form Password
                  CustomTextField(
                    label: 'Password',
                    hint: 'Minimal 8 karakter',
                    controller: _passCtrl,
                    isPassword: !_showPass,
                    validator: (v) => (v?.length ?? 0) < 8 ? 'Password minimal 8 karakter' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Form Konfirmasi Password
                  CustomTextField(
                    label: 'Konfirmasi Password',
                    hint: 'Ulangi password',
                    controller: _pass2Ctrl,
                    isPassword: !_showPass,
                    validator: (v) => v != _passCtrl.text ? 'Password tidak cocok' : null,
                  ),
                  
                  // Tombol Mata untuk Show/Hide Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => setState(() => _showPass = !_showPass),
                      icon: Icon(
                        _showPass ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade600,
                        size: 18,
                      ),
                      label: Text(
                        _showPass ? 'Sembunyikan Password' : 'Lihat Password',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}