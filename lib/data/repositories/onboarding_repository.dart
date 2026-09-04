import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class OnboardingRepository {
  final ApiClient _apiClient;

  OnboardingRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<OnboardingProgress> getProgress() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/onboarding/progress',
    );
    return OnboardingProgress.fromJson(response);
  }

  Future<OnboardingProgress> updateStep(int step, {Map<String, dynamic>? data}) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/onboarding/progress',
      data: {
        'current_step': step,
        if (data != null) 'step_data': data,
      },
    );
    return OnboardingProgress.fromJson(response);
  }

  Future<SoftScan> submitSoftScan(Map<String, dynamic> scanData) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/onboarding/soft-scan',
      data: scanData,
    );
    return SoftScan.fromJson(response);
  }

  Future<void> savePrivacyConsent(Map<String, dynamic> consents) async {
    final consentMap = {
      'analytics_consent': consents['analytics_consent'] ?? false,
      'marketing_consent': consents['marketing_consent'] ?? false,
      'third_party_sharing': consents['third_party_sharing'] ?? false,
      'data_collection': consents['data_collection'] ?? false,
    };

    for (final entry in consentMap.entries) {
      await _apiClient.post<Map<String, dynamic>>(
        '/onboarding/privacy-consent',
        data: {
          'category': entry.key,
          'consented': entry.value,
        },
      );
    }
  }

  Future<Map<String, dynamic>> saveCycleBaseline(Map<String, dynamic> baseline) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/onboarding/cycle-baseline',
      data: baseline,
    );
    return response;
  }

  Future<Map<String, dynamic>> connectWearable({
    required String provider,
    required String deviceId,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/onboarding/wearable',
      data: {
        'provider': provider,
        'device_id': deviceId,
      },
    );
    return response;
  }
}
