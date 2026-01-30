import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(text: user?.phoneNumber);
    _addressController = TextEditingController(text: user?.address);
  }

  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _pickedFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    
    String? photoUrl;
    if (user?.photo != null && _pickedFile == null) {
      final fileName = user!.photo!.split('/').last;
      photoUrl = '${ApiService.baseUrl}/profile-image/$fileName';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF0D5),
      appBar: AppBar(
        title: const Text('Edit Informasi Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF003049),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    _buildProfileImage(photoUrl),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color(0xFF780000), shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildInputLabel('Nama Lengkap'),
              _buildModernField(_nameController, Icons.person_outline),
              const SizedBox(height: 20),
              _buildInputLabel('Email'),
              _buildModernField(_emailController, Icons.email_outlined),
              const SizedBox(height: 20),
              _buildInputLabel('Nomor HP'),
              _buildModernField(_phoneController, Icons.phone_android_rounded),
              const SizedBox(height: 20),
              _buildInputLabel('Alamat'),
              _buildModernField(_addressController, Icons.location_on_outlined, maxLines: 3),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003049),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: auth.isLoading ? null : () async {
                    final success = await auth.updateProfile(
                      _nameController.text,
                      _phoneController.text,
                      _addressController.text,
                      _emailController.text,
                      photo: _pickedFile,
                    );
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
                      Navigator.pop(context);
                    }
                  },
                  child: auth.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('SIMPAN PERUBAHAN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF003049))),
      ),
    );
  }

  Widget _buildModernField(TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF003049), width: 1.5)),
      ),
    );
  }

  Widget _buildProfileImage(String? photoUrl) {
    if (_pickedFile != null) {
      if (kIsWeb) return CircleAvatar(radius: 60, backgroundImage: NetworkImage(_pickedFile!.path));
      return CircleAvatar(radius: 60, backgroundImage: FileImage(File(_pickedFile!.path)));
    }
    if (photoUrl != null) return CircleAvatar(radius: 60, backgroundImage: NetworkImage(photoUrl));
    return const CircleAvatar(radius: 60, backgroundColor: Color(0xFF003049), child: Icon(Icons.person, size: 60, color: Colors.white));
  }
}