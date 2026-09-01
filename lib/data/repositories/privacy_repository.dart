import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class PrivacyRepository {
  final ApiClient _apiClient;

  PrivacyRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<PrivacyConsent> getConsents() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/privacy/consents');
    return PrivacyConsent.fromJson(response);
  }

  Future<PrivacyConsent> updateConsent({
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
    return PrivacyConsent.fromJson(response);
  }

  Future<Map<String, dynamic>> requestDataExport() async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/privacy/export',
    );
    return response;
  }

  Future<Map<String, dynamic>> requestAccountDeletion() async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/privacy/delete-account',
    );
    return response;
  }
}
