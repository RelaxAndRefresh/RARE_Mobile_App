import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class CommerceRepository {
  final ApiClient _apiClient;

  CommerceRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<Cart> getCart() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/commerce/cart');
    return Cart.fromJson(response);
  }

  Future<Cart> addToCart({
    required String productId,
    int quantity = 1,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/commerce/cart/items',
      data: {
        'product_id': productId,
        'quantity': quantity,
      },
    );
    return Cart.fromJson(response);
  }

  Future<Cart> removeFromCart(String itemId) async {
    final response = await _apiClient.delete<Map<String, dynamic>>(
      '/commerce/cart/items/$itemId',
    );
    return Cart.fromJson(response);
  }

  Future<Cart> updateCartItem(String itemId, int quantity) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/commerce/cart/items/$itemId',
      data: {'quantity': quantity},
    );
    return Cart.fromJson(response);
  }

  Future<Order> checkout({required String address}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/commerce/checkout',
      data: {'shipping_address': address},
    );
    return Order.fromJson(response);
  }

  Future<Payment> verifyPayment(Map<String, dynamic> paymentData) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/commerce/payment/verify',
      data: paymentData,
    );
    return Payment.fromJson(response);
  }
}
