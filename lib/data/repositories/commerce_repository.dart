import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class CommerceRepository {
  final ApiClient _apiClient;

  CommerceRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<Cart> getCart() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/commerce/cart');
    final items = (response['items'] as List<dynamic>? ?? [])
        .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
        .toList();
    final total = (response['total'] as num?)?.toDouble() ?? 0;
    return Cart(
      id: response['id']?.toString() ?? '',
      userId: '',
      items: items,
      totalAmount: total,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<Map<String, dynamic>> addToCart({
    required int productId,
    int quantity = 1,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/commerce/cart/items',
      data: {
        'product_id': productId,
        'quantity': quantity,
      },
    );
    return response;
  }

  Future<Map<String, dynamic>> removeFromCart(int itemId) async {
    final response = await _apiClient.delete<Map<String, dynamic>>(
      '/commerce/cart/items/$itemId',
    );
    return response;
  }

  Future<Map<String, dynamic>> updateCartItem(int itemId, int quantity) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/commerce/cart/items/$itemId',
      data: {
        'product_id': 0,
        'quantity': quantity,
      },
    );
    return response;
  }

  Future<Map<String, dynamic>> checkout({
    required Map<String, dynamic> address,
    String paymentMethod = 'razorpay',
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/commerce/checkout',
      data: {
        'shipping_address': address,
        'payment_method': paymentMethod,
      },
    );
    return response;
  }

  Future<Map<String, dynamic>> verifyPayment(Map<String, dynamic> paymentData) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/commerce/payment/verify',
      data: paymentData,
    );
    return response;
  }
}
