import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_config.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';

class ApiClient {
  late final Dio _dio;
  late final AuthInterceptor _authInterceptor;
  final FlutterSecureStorage _secureStorage;

  ApiClient({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      headers: ApiConfig.defaultHeaders,
    ));

    _authInterceptor = AuthInterceptor(
      secureStorage: _secureStorage,
      dio: _dio,
    );

    _dio.interceptors.addAll([
      _authInterceptor,
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[API] $obj'),
      ),
    ]);
  }

  FlutterSecureStorage get secureStorage => _secureStorage;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> uploadFile(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (data != null) ...data,
        fieldName: await MultipartFile.fromFile(filePath),
      });

      await _dio.post(
        path,
        data: formData,
        options: headers != null ? Options(headers: headers) : null,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<String> downloadFile(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
      return savePath;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> logout() async {
    await _authInterceptor.clearAllAuth();
  }

  T _handleResponse<T>(Response response, T Function(Map<String, dynamic>)? fromJson) {
    final responseData = response.data;

    if (responseData is Map<String, dynamic>) {
      if (fromJson != null) {
        final data = responseData['data'];
        if (data is Map<String, dynamic>) {
          return fromJson(data);
        } else if (data == null) {
          throw ApiException(
            statusCode: response.statusCode,
            message: 'No data in response',
          );
        }
        return fromJson(responseData);
      }

      return responseData as T;
    }

    if (fromJson != null && responseData is List) {
      return responseData as T;
    }

    return responseData as T;
  }

  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Connection timed out. Please try again.',
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection. Please check your network.',
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response!);
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled.');
      case DioExceptionType.badCertificate:
        return ApiException(message: 'Certificate verification failed.');
      case DioExceptionType.unknown:
        return NetworkException(
          message: e.message ?? 'An unexpected error occurred.',
        );
    }
  }

  ApiException _handleBadResponse(Response response) {
    final statusCode = response.statusCode;
    final data = response.data as Map<String, dynamic>?;
    final message = data?['message'] as String? ?? 'An error occurred';
    final errors = data?['errors'];

    switch (statusCode) {
      case 400:
        return ApiException(
          statusCode: statusCode,
          message: message,
          errors: errors,
        );
      case 401:
        return AuthException(statusCode: statusCode, message: message);
      case 403:
        return ForbiddenException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 422:
        return ValidationException(message: message, fieldErrors: errors is Map ? errors.cast<String, dynamic>() : null);
      case 500:
      case 502:
      case 503:
        return ServerException(statusCode: statusCode, message: message);
      default:
        return ApiException(
          statusCode: statusCode,
          message: message,
          errors: errors,
        );
    }
  }
}
