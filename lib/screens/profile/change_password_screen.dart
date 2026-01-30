import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _obscure3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0D5),
      appBar: AppBar(
        title: const Text('Ganti Password', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF003049),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Keamanan Akun',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF003049)),
              ),
              const Text('Pastikan password baru Anda sulit ditebak orang lain', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 40),
              _buildLabel('Password Lama'),
              _buildPasswordField(_currentController, _obscure1, (v) => setState(() => _obscure1 = v)),
              const SizedBox(height: 20),
              _buildLabel('Password Baru'),
              _buildPasswordField(_newController, _obscure2, (v) => setState(() => _obscure2 = v)),
              const SizedBox(height: 20),
              _buildLabel('Konfirmasi Password Baru'),
              _buildPasswordField(_confirmController, _obscure3, (v) => setState(() => _obscure3 = v)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF780000),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _isLoading ? null : _handleChangePassword,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('GANTI PASSWORD', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF003049))),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, bool obscure, Function(bool) onToggle) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: () => onToggle(!obscure),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF780000), width: 1.5)),
      ),
    );
  }

  Future<void> _handleChangePassword() async {
    setState(() => _isLoading = true);
    try {
      await ApiService().changePassword(
        _currentController.text, 
        _newController.text, 
        _confirmController.text
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password berhasil diubah')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengganti password. Periksa kembali password lama Anda.')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}