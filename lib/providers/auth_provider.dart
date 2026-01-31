import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  User? get user => _user;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return;

    _token = prefs.getString('token');
    notifyListeners();
    
    // Refresh user data
    try {
      final response = await _apiService.getUser();
      _user = User.fromJson(response.data);
      notifyListeners();
    } catch (e) {
      // Token might be invalid
      logout();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.login(email, password);
      _token = response.data['access_token'];
      _user = User.fromJson(response.data['user']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.register(name, email, password);
      _token = response.data['access_token'];
      _user = User.fromJson(response.data['user']);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      // Ignore network errors on logout
    }
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<bool> updateProfile(String name, String phone, String address, String email, {XFile? photo}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final Map<String, dynamic> map = {
        'name': name,
        'email': email,
        'phone_number': phone,
        'address': address,
      };

      if (photo != null) {
        if (kIsWeb) {
          final bytes = await photo.readAsBytes();
          map['photo'] = MultipartFile.fromBytes(bytes, filename: photo.name);
        } else {
          map['photo'] = await MultipartFile.fromFile(photo.path, filename: photo.name);
        }
      }

      final formData = FormData.fromMap(map);
      final response = await _apiService.updateProfile(formData);
      _user = User.fromJson(response.data['user']);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Update Profile Error: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
