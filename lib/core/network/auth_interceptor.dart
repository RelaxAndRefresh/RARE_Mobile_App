import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_config.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final Dio _dio;

  AuthInterceptor({
    required FlutterSecureStorage secureStorage,
    required Dio dio,
  })  : _secureStorage = secureStorage,
        _dio = dio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: 'access_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _secureStorage.read(key: 'refresh_token');
        if (refreshToken == null || refreshToken.isEmpty) {
          await _clearTokens();
          handler.next(err);
          return;
        }

        final response = await _dio.post(
          '${ApiConfig.baseUrl}/auth/refresh',
          data: {'refresh_token': refreshToken},
          options: Options(
            headers: {'Authorization': null},
          ),
        );

        if (response.statusCode == 200) {
          final data = response.data['data'] ?? response.data;
          final newAccessToken = data['access_token'] as String?;
          final newRefreshToken = data['refresh_token'] as String?;

          if (newAccessToken != null) {
            await _secureStorage.write(
              key: 'access_token',
              value: newAccessToken,
            );
          }
          if (newRefreshToken != null) {
            await _secureStorage.write(
              key: 'refresh_token',
              value: newRefreshToken,
            );
          }

          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryResponse = await _dio.fetch(requestOptions);
          handler.resolve(retryResponse);
          return;
        }
      } catch (e) {
        await _clearTokens();
      }
    }
    handler.next(err);
  }

  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
    await _secureStorage.delete(key: 'user_data');
  }

  Future<void> clearAllAuth() async {
    await _clearTokens();
  }
}
