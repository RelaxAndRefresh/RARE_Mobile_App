import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class InsightRepository {
  final ApiClient _apiClient;

  InsightRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<BiweeklyInsight>> getBiweeklyInsights({int? limit}) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;

    final response = await _apiClient.get<List<dynamic>>(
      '/insights/biweekly',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => BiweeklyInsight.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MonthlyInsight>> getMonthlyInsights({int? limit}) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;

    final response = await _apiClient.get<List<dynamic>>(
      '/insights/monthly',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => MonthlyInsight.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<PulseFeedItem>> getPulseFeed({int? limit, int? offset}) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final response = await _apiClient.get<List<dynamic>>(
      '/insights/pulse-feed',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => PulseFeedItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
