import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class ShelfRepository {
  final ApiClient _apiClient;

  ShelfRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<ShelfItem>> getShelf() async {
    final response = await _apiClient.get<List<dynamic>>('/shelf');
    return response
        .map((e) => ShelfItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ShelfItem> confirmDepletion(String itemId, bool stillHave) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/shelf/$itemId/depletion',
      data: {'still_have': stillHave},
    );
    return ShelfItem.fromJson(response);
  }

  Future<ShelfItem> toggleAutoSwap(String itemId, bool enabled) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/shelf/$itemId/auto-swap',
      data: {'enabled': enabled},
    );
    return ShelfItem.fromJson(response);
  }

  Future<List<Product>> getProducts({
    String? category,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final response = await _apiClient.get<List<dynamic>>(
      '/products',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Product> getProduct(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/products/$id');
    return Product.fromJson(response);
  }
}
