import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/legal_repository.dart';
import 'auth_provider.dart';

class LegalState {
  final bool isLoading;
  final LegalDocument? document;
  final String? error;

  LegalState({
    this.isLoading = false,
    this.document,
    this.error,
  });

  LegalState copyWith({
    bool? isLoading,
    LegalDocument? document,
    String? error,
  }) {
    return LegalState(
      isLoading: isLoading ?? this.isLoading,
      document: document ?? this.document,
      error: error,
    );
  }
}

final legalRepositoryProvider = Provider<LegalRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return LegalRepository(apiClient: authRepo.apiClient);
});

final legalProvider =
    StateNotifierProvider<LegalNotifier, LegalState>((ref) {
  final repository = ref.watch(legalRepositoryProvider);
  return LegalNotifier(repository);
});

class LegalNotifier extends StateNotifier<LegalState> {
  final LegalRepository _repository;

  LegalNotifier(this._repository) : super(LegalState());

  Future<void> loadDocument(String type) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final document = await _repository.getDocument(type);
      state = state.copyWith(isLoading: false, document: document);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
