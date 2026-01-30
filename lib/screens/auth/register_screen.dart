import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF003049), Color(0xFF669BBC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Container(
                padding: const EdgeInsets.all(32),
                constraints: const BoxConstraints(maxWidth: 450),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF0D5),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 15))],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Daftar Akun',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF003049)),
                      ),
                      const SizedBox(height: 8),
                      const Text('Bergabung dengan Busket sekarang', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 40),
                      _buildTextField(_nameController, 'Nama Lengkap', Icons.person_outline),
                      const SizedBox(height: 16),
                      _buildTextField(_emailController, 'Email', Icons.email_outlined),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _passwordController, 
                        'Password', 
                        Icons.lock_outline, 
                        isPassword: true,
                        obscure: _obscureText,
                        onToggle: () => setState(() => _obscureText = !_obscureText),
                      ),
                      const SizedBox(height: 32),
                      authProvider.isLoading
                          ? const CircularProgressIndicator(color: Color(0xFF003049))
                          : SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF780000),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 5,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await authProvider.register(
                                      _nameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                    if (success && context.mounted) {
                                      Navigator.popUntil(context, (route) => route.isFirst);
                                    } else if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Gagal mendaftar. Cek kembali data Anda.')),
                                      );
                                    }
                                  }
                                },
                                child: const Text('DAFTAR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                              ),
                            ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Sudah punya akun? ", style: TextStyle(color: Colors.grey)),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              "Login Disini",
                              style: TextStyle(color: Color(0xFF003049), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isPassword = false, bool obscure = false, VoidCallback? onToggle}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Color(0xFF003049)),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF003049)),
        suffixIcon: isPassword ? IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey), onPressed: onToggle) : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      validator: (v) => v!.isEmpty ? '$hint wajib diisi' : null,
    );
  }
}