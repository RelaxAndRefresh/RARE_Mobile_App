import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class CreditsRepository {
  final ApiClient _apiClient;

  CreditsRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<CreditBalance> getBalance() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/credits/balance');
    return CreditBalance.fromJson(response);
  }

  Future<List<CreditTransaction>> getTransactions({
    String? type,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{};
    if (type != null) queryParams['type'] = type;
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final response = await _apiClient.get<List<dynamic>>(
      '/credits/transactions',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => CreditTransaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
