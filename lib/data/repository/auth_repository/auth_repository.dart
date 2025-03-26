import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/constants/app_urls.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  /// Initiates the login process by requesting an OTP
  Future<void> initiateLogin(String number, [BuildContext? context]) async {
    if (number.isEmpty) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a phone number')),
        );
      }
      return;
    }

    try {
      final response = await dio.post(
        '${AppUrls.supabaseUrl}/auth/v1/otp',
        options: Options(
          headers: {
            'apiKey': AppUrls.supabaseKey,
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'phone': number,
        },
      );

      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Initiated: ${response.statusCode}')),
        );
      }
    } on DioException catch (e) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.response?.data ?? e.message}')),
        );
      }
      rethrow;
    }
  }

  /// Verifies the OTP sent to the user's phone
  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      final response = await dio.post(
        '${AppUrls.supabaseUrl}/auth/v1/verify',
        options: Options(
          headers: {
            'apiKey': AppUrls.supabaseKey,
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'type': 'sms',
          'phone': phone,
          'token': otp,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }
}
