import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api_models.dart';
import '../../data/repositories/shelf_repository.dart';
import 'auth_provider.dart';

class ShelfState {
  final bool isLoading;
  final List<ShelfItem> shelfItems;
  final List<Product> products;
  final String? error;

  ShelfState({
    this.isLoading = false,
    this.shelfItems = const [],
    this.products = const [],
    this.error,
  });

  ShelfState copyWith({
    bool? isLoading,
    List<ShelfItem>? shelfItems,
    List<Product>? products,
    String? error,
  }) {
    return ShelfState(
      isLoading: isLoading ?? this.isLoading,
      shelfItems: shelfItems ?? this.shelfItems,
      products: products ?? this.products,
      error: error,
    );
  }
}

final shelfRepositoryProvider = Provider<ShelfRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return ShelfRepository(apiClient: authRepo.apiClient);
});

final shelfProvider = StateNotifierProvider<ShelfNotifier, ShelfState>((ref) {
  final repository = ref.watch(shelfRepositoryProvider);
  return ShelfNotifier(repository);
});

class ShelfNotifier extends StateNotifier<ShelfState> {
  final ShelfRepository _repository;

  ShelfNotifier(this._repository) : super(ShelfState());

  Future<void> loadShelf() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final items = await _repository.getShelf();
      state = state.copyWith(isLoading: false, shelfItems: items);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadProducts({
    String? category,
    String? search,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await _repository.getProducts(
        category: category,
        search: search,
      );
      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> confirmDepletion(String itemId, bool stillHave) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updated = await _repository.confirmDepletion(itemId, stillHave);
      final items = state.shelfItems.map((item) {
        return item.id == itemId ? updated : item;
      }).toList();
      state = state.copyWith(isLoading: false, shelfItems: items);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleAutoSwap(String itemId, bool enabled) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updated = await _repository.toggleAutoSwap(itemId, enabled);
      final items = state.shelfItems.map((item) {
        return item.id == itemId ? updated : item;
      }).toList();
      state = state.copyWith(isLoading: false, shelfItems: items);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getProduct(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final product = await _repository.getProduct(id);
      final existingIndex = state.products.indexWhere((p) => p.id == id);
      final products = List<Product>.from(state.products);
      if (existingIndex >= 0) {
        products[existingIndex] = product;
      } else {
        products.add(product);
      }
      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
