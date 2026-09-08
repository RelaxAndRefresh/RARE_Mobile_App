import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class EnvironmentalRepository {
  final ApiClient _apiClient;

  EnvironmentalRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<EnvironmentalData> getCurrentEnvironmentalData() async {
    final response =
        await _apiClient.get<Map<String, dynamic>>('/environmental/current');
    return EnvironmentalData.fromJson(response);
  }

  Future<List<EnvironmentalData>> getEnvironmentalHistory({int? limit}) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;

    final response = await _apiClient.get<List<dynamic>>(
      '/environmental/history',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => EnvironmentalData.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
