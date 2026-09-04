import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api_models.dart';
import '../../data/repositories/commerce_repository.dart';
import 'auth_provider.dart';

class CommerceState {
  final bool isLoading;
  final Cart? cart;
  final List<Map<String, dynamic>> recentOrders;
  final String? error;

  CommerceState({
    this.isLoading = false,
    this.cart,
    this.recentOrders = const [],
    this.error,
  });

  CommerceState copyWith({
    bool? isLoading,
    Cart? cart,
    List<Map<String, dynamic>>? recentOrders,
    String? error,
  }) {
    return CommerceState(
      isLoading: isLoading ?? this.isLoading,
      cart: cart ?? this.cart,
      recentOrders: recentOrders ?? this.recentOrders,
      error: error,
    );
  }
}

final commerceRepositoryProvider = Provider<CommerceRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return CommerceRepository(apiClient: authRepo.apiClient);
});

final commerceProvider =
    StateNotifierProvider<CommerceNotifier, CommerceState>((ref) {
  final repository = ref.watch(commerceRepositoryProvider);
  return CommerceNotifier(repository);
});

class CommerceNotifier extends StateNotifier<CommerceState> {
  final CommerceRepository _repository;

  CommerceNotifier(this._repository) : super(CommerceState());

  int get cartItemCount => state.cart?.items.length ?? 0;
  double get cartTotal => state.cart?.totalAmount ?? 0;

  Future<void> loadCart() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cart = await _repository.getCart();
      state = state.copyWith(isLoading: false, cart: cart);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addToCart({
    required int productId,
    int quantity = 1,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.addToCart(productId: productId, quantity: quantity);
      await loadCart();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> removeFromCart(int itemId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.removeFromCart(itemId);
      await loadCart();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateCartItem(int itemId, int quantity) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateCartItem(itemId, quantity);
      await loadCart();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<Map<String, dynamic>> checkout({
    required Map<String, dynamic> address,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final order = await _repository.checkout(address: address);
      state = state.copyWith(
        isLoading: false,
        cart: null,
        recentOrders: [order, ...state.recentOrders],
      );
      return order;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyPayment(Map<String, dynamic> paymentData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.verifyPayment(paymentData);
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
