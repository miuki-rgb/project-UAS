import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiService {
  static String get baseUrl {
    // Gunakan alamat Railway yang sudah online
    return 'https://web-admin-pemesanan-tiket-bis-production.up.railway.app/api';
  }
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle errors globally if needed
        return handler.next(e);
      }
    ));
  }

  // Auth
  Future<Response> login(String email, String password) async {
    return await _dio.post('/login', data: {'email': email, 'password': password});
  }

  Future<Response> register(String name, String email, String password) async {
    return await _dio.post('/register', data: {
      'name': name, 
      'email': email, 
      'password': password
    });
  }

  Future<Response> logout() async {
    return await _dio.post('/logout');
  }

  Future<Response> getUser() async {
    return await _dio.get('/user');
  }

  Future<Response> updateProfile(FormData data) async {
    return await _dio.post('/profile', data: data);
  }
  
  Future<Response> changePassword(String currentPassword, String newPassword, String confirmation) async {
    return await _dio.post('/change-password', data: {
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': confirmation,
    });
  }

  // Data
  Future<Response> getSchedules({String? origin, String? destination, String? date}) async {
    Map<String, dynamic> params = {};
    if (origin != null && origin.isNotEmpty) params['origin'] = origin;
    if (destination != null && destination.isNotEmpty) params['destination'] = destination;
    if (date != null && date.isNotEmpty) params['date'] = date;
    
    return await _dio.get('/schedules', queryParameters: params);
  }

  Future<Response> getLocations() async {
    return await _dio.get('/locations');
  }

  Future<Response> getAnnouncements() async {
    return await _dio.get('/announcements');
  }

  Future<Response> createBooking(int scheduleId, int quantity, String paymentMethod) async {
    return await _dio.post('/bookings', data: {
      'schedule_id': scheduleId,
      'quantity': quantity,
      'payment_method': paymentMethod
    });
  }

  Future<Response> getMyTickets() async {
    return await _dio.get('/my-tickets');
  }

  Future<Response> scanTicket(String qrData) async {
    return await _dio.post('/scan-ticket', data: {'qr_code_data': qrData});
  }
}
