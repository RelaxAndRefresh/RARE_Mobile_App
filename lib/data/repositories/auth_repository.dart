import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../models/api_models.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  AuthRepository({
    ApiClient? apiClient,
    FlutterSecureStorage? secureStorage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  ApiClient get apiClient => _apiClient;

  Future<AuthResponse> signup({
    required String email,
    required String name,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/signup',
      data: {
        'email': email,
        'name': name,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response);
    await _storeTokens(authResponse.tokens);
    await _storeUser(authResponse.user);
    return authResponse;
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response);
    await _storeTokens(authResponse.tokens);
    await _storeUser(authResponse.user);
    return authResponse;
  }

  Future<AuthTokens> refreshToken(String refreshToken) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    final tokens = AuthTokens.fromJson(response);
    await _storeTokens(tokens);
    return tokens;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // Continue with local logout even if server call fails
    } finally {
      await _clearTokens();
      await _apiClient.logout();
    }
  }

  Future<User> getCurrentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/auth/me');
    final user = User.fromJson(response);
    await _storeUser(user);
    return user;
  }

  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: 'access_token');
    return token != null && token.isNotEmpty;
  }

  Future<User?> getStoredUser() async {
    final userData = await _secureStorage.read(key: 'user_data');
    if (userData == null || userData.isEmpty) return null;
    try {
      final json = jsonDecode(userData) as Map<String, dynamic>;
      return User.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> _storeTokens(AuthTokens tokens) async {
    await _secureStorage.write(key: 'access_token', value: tokens.accessToken);
    await _secureStorage.write(key: 'refresh_token', value: tokens.refreshToken);
  }

  Future<void> _storeUser(User user) async {
    await _secureStorage.write(key: 'user_data', value: jsonEncode(user.toJson()));
  }

  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
    await _secureStorage.delete(key: 'user_data');
  }
}
