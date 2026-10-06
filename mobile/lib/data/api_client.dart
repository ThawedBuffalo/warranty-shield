/// API Client - Remote Data Source
///
/// Sprint 1: SCRUM-866 (Warranty Data Model & Storage)
/// Sprint 1: SCRUM-867 (Firebase Auth & Session Management)
///
/// Handles HTTP communication with the Java backend REST API.

import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;
  String? _token;

  ApiClient({String? baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? 'http://localhost:8080/api',
          contentType: 'application/json',
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        )) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next();
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Token expired or invalid - trigger re-authentication
            _token = null;
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// Set the authentication token
  void setToken(String token) {
    _token = token;
  }

  /// Clear the authentication token
  void clearToken() {
    _token = null;
  }

  /// Authenticate user and get JWT token
  Future<Map<String, dynamic>> authenticate({
    required String firebaseUid,
    required String email,
    String? deviceToken,
  }) async {
    final response = await _dio.post(
      '/auth/authenticate',
      data: {
        'firebaseUid': firebaseUid,
        'email': email,
        if (deviceToken != null) 'deviceToken': deviceToken,
      },
    );
    final data = response.data as Map<String, dynamic>;
    this._token = data['token'] as String;
    return data;
  }

  /// Create a warranty
  Future<Map<String, dynamic>> createWarranty(
    String userId, {
    required String productName,
    required String purchaseDate,
    required int warrantyDurationMonths,
    required String retailer,
    required double price,
  }) async {
    final response = await _dio.post(
      '/warranties',
      data: {
        'productName': productName,
        'purchaseDate': purchaseDate,
        'warrantyDurationMonths': warrantyDurationMonths,
        'retailer': retailer,
        'price': price,
      },
      options: Options(headers: {'X-User-Id': userId}),
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get all warranties for a user
  Future<List<Map<String, dynamic>>> getWarranties(String userId) async {
    final response = await _dio.get(
      '/warranties',
      options: Options(headers: {'X-User-Id': userId}),
    );
    return List<Map<String, dynamic>>.from(response.data);
  }

  /// Get a single warranty
  Future<Map<String, dynamic>> getWarranty(String userId, String id) async {
    final response = await _dio.get(
      '/warranties/$id',
      options: Options(headers: {'X-User-Id': userId}),
    );
    return response.data as Map<String, dynamic>;
  }

  /// Update a warranty
  Future<Map<String, dynamic>> updateWarranty(
    String userId, {
    required String id,
    required String productName,
    required String purchaseDate,
    required int warrantyDurationMonths,
    required String retailer,
    required double price,
  }) async {
    final response = await _dio.put(
      '/warranties/$id',
      data: {
        'productName': productName,
        'purchaseDate': purchaseDate,
        'warrantyDurationMonths': warrantyDurationMonths,
        'retailer': retailer,
        'price': price,
      },
      options: Options(headers: {'X-User-Id': userId}),
    );
    return response.data as Map<String, dynamic>;
  }

  /// Delete a warranty
  Future<void> deleteWarranty(String userId, String id) async {
    await _dio.delete(
      '/warranties/$id',
      options: Options(headers: {'X-User-Id': userId}),
    );
  }

  /// Get expiring warranties
  Future<List<Map<String, dynamic>>> getExpiringWarranties(
    String userId,
  ) async {
    final response = await _dio.get(
      '/warranties/expiring',
      options: Options(headers: {'X-User-Id': userId}),
    );
    return List<Map<String, dynamic>>.from(response.data);
  }
}