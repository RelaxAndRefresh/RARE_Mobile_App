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

  Future<Map<String, dynamic>> login({
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

    await _secureStorage.write(
      key: 'practitioner_access_token',
      value: response['access_token']?.toString() ?? '',
    );
    return response;
  }

  Future<Map<String, dynamic>> getClientSummary(String clientId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/practitioner/clients/$clientId/summary',
    );
    return response;
  }

  Future<Map<String, dynamic>> createSession(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/practitioner/sessions',
      data: data,
    );
    return response;
  }

  Future<Map<String, dynamic>> getProtocol(String sessionId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/practitioner/sessions/$sessionId/protocol',
    );
    return response;
  }

  Future<List<Map<String, dynamic>>> getClients({String? search}) async {
    final queryParams = <String, dynamic>{};
    if (search != null) queryParams['search'] = search;

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/practitioner/clients',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    final clients = response['clients'] as List<dynamic>? ?? [];
    return clients.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getSessions({
    String? clientId,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{};
    if (clientId != null) queryParams['client_id'] = clientId;
    if (limit != null) queryParams['limit'] = limit;

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/practitioner/sessions',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    final sessions = response['sessions'] as List<dynamic>? ?? [];
    return sessions.cast<Map<String, dynamic>>();
  }
}
