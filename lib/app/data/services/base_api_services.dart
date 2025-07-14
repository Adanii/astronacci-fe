import 'dart:developer';

import 'package:astronacci_fe/core/api_routes.dart';
import 'package:dio/dio.dart';

class BaseApiService {
  final Dio _dio;

  BaseApiService._internal(this._dio);

  // Singleton pattern supaya cuma ada 1 instance Dio di app
  static final BaseApiService _instance = BaseApiService._internal(
    Dio(
      BaseOptions(
        baseUrl: ApiRoutes.url,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    ),
  );

  factory BaseApiService() {
    return _instance;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      log('[BaseApiService] POST $path');
      log('[BaseApiService] Payload: $data');
      final response = await _dio.post(path, data: data);
      log('[BaseApiService] Response: ${response.statusCode}');
      return response;
    } on DioException catch (e) {
      log('[BaseApiService]  DioError: ${e.message}');
      if (e.response != null) {
        log('[BaseApiService] Response Data: ${e.response?.data}');
        log('[BaseApiService] Status Code: ${e.response?.statusCode}');
      }
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        log('[BaseApiService] Response Data: ${e.response?.data}');
        log('[BaseApiService] Status Code: ${e.response?.statusCode}');
      }
      rethrow;
    }
  }

  Future<Response> delete(String path, {dynamic data}) async {
    try {
      final response = await _dio.delete(path, data: data);

      return response;
    } on DioException catch (e) {
      log('[BaseApiService] DioError: ${e.message}');
      if (e.response != null) {
        log('[BaseApiService] Response Data: ${e.response?.data}');
        log('[BaseApiService] Status Code: ${e.response?.statusCode}');
      }
      rethrow;
    }
  }

  // Tambahkan put, delete jika perlu

  String _handleError(DioException e) {
    if (e.response != null) {
      // Coba ambil 'msg' dari body JSON jika ada, fallback ke statusMessage
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data.containsKey('msg')) {
        return data['msg'];
      } else {
        return 'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
      }
    } else {
      return 'Error: ${e.message}';
    }
  }
}
