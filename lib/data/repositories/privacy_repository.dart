import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class PrivacyRepository {
  final ApiClient _apiClient;

  PrivacyRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<Map<String, dynamic>>> getConsents() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/privacy/consents');
    final consents = response['consents'] as List<dynamic>? ?? [];
    return consents.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> updateConsent({
    required String category,
    required bool consented,
  }) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/privacy/consents',
      data: {
        'category': category,
        'consented': consented,
      },
    );
    return response;
  }

  Future<Map<String, dynamic>> requestDataExport() async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/privacy/export',
      data: {'export_type': 'full'},
    );
    return response;
  }

  Future<Map<String, dynamic>> requestAccountDeletion({String? reason}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/privacy/delete-account',
      data: {
        'confirmation': 'DELETE_MY_ACCOUNT',
        if (reason != null) 'reason': reason,
      },
    );
    return response;
  }
}
