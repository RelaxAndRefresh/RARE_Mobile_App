import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class PractitionerRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  PractitionerRepository({
    ApiClient? apiClient,
    FlutterSecureStorage? secureStorage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/practitioner/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response);
    await _secureStorage.write(
      key: 'access_token',
      value: authResponse.tokens.accessToken,
    );
    await _secureStorage.write(
      key: 'refresh_token',
      value: authResponse.tokens.refreshToken,
    );
    return authResponse;
  }

  Future<PractitionerClient> getClientSummary(String clientId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/practitioner/clients/$clientId/summary',
    );
    return PractitionerClient.fromJson(response);
  }

  Future<TreatmentSession> createSession(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/practitioner/sessions',
      data: data,
    );
    return TreatmentSession.fromJson(response);
  }

  Future<Map<String, dynamic>> getProtocol(String sessionId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/practitioner/sessions/$sessionId/protocol',
    );
    return response;
  }

  Future<List<PractitionerClient>> getClients({String? search}) async {
    final queryParams = <String, dynamic>{};
    if (search != null) queryParams['search'] = search;

    final response = await _apiClient.get<List<dynamic>>(
      '/practitioner/clients',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => PractitionerClient.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TreatmentSession>> getSessions({
    String? clientId,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{};
    if (clientId != null) queryParams['client_id'] = clientId;
    if (limit != null) queryParams['limit'] = limit;

    final response = await _apiClient.get<List<dynamic>>(
      '/practitioner/sessions',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => TreatmentSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
