import 'package:astronacci_fe/app/data/models/user_model.dart';
import 'package:astronacci_fe/app/data/services/base_api_services.dart';
import 'package:astronacci_fe/core/api_routes.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final BaseApiService _apiService = BaseApiService();
  final _client = Supabase.instance.client;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.login,
        data: {'email': email, 'password': password},
      );

      return response.data;
    } on DioException catch (e) {
      // Supabase error message
      final msg =
          e.response?.data['msg'] ??
          e.response?.data['error'] ??
          'Unknown error occurred';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<Map<String, dynamic>> register(UserModel user) async {
    final response = await _apiService.post(
      ApiRoutes.registration,
      data: user.toJsonRegister(),
    );

    // Status sukses 201 (Created)
    if (response.statusCode == 201) {
      return response.data;
    }

    // Tangani error seperti 409, 400, dll
    if (response.statusCode != 200) {
      final msg = response.data['user'] ?? 'Terjadi kesalahan saat registrasi';
      throw Exception(msg);
    }

    return response.data;
  }

  Future<void> logout() async {
    final response = await _apiService.post(ApiRoutes.logout);

    if (response.statusCode != 200) {
      final msg = response.data['error'] ?? 'Gagal logout dari server';
      throw Exception(msg);
    }
  }

  /// Kirim email reset password
  Future<void> sendForgotPasswordEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'astronacciapp://reset-password', // URI deep link kamu
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to send forgot password email: $e');
    }
  }

  /// Update password baru (setelah user klik link recovery)
  Future<void> updatePassword(String newPassword) async {
    try {
      final res = await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      if (res.user == null) {
        throw Exception('Failed to update password');
      }
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  Future<Map<String, dynamic>> updateUser(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiService.put(
      '${ApiRoutes.updateUser}/$userId',
      data: data,
    );

    if (response.statusCode == 200) {
      return response.data['user'];
    } else {
      throw Exception(response.data['error'] ?? 'Failed to update user');
    }
  }
}
