import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/privacy_repository.dart';
import 'auth_provider.dart';

class PrivacyState {
  final bool isLoading;
  final List<Map<String, dynamic>> consents;
  final String? error;
  final String? successMessage;

  PrivacyState({
    this.isLoading = false,
    this.consents = const [],
    this.error,
    this.successMessage,
  });

  PrivacyState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? consents,
    String? error,
    String? successMessage,
  }) {
    return PrivacyState(
      isLoading: isLoading ?? this.isLoading,
      consents: consents ?? this.consents,
      error: error,
      successMessage: successMessage,
    );
  }

  bool getConsent(String category) {
    for (final c in consents) {
      if (c['category'] == category) {
        return c['consented'] == true;
      }
    }
    return false;
  }
}

final privacyRepositoryProvider = Provider<PrivacyRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return PrivacyRepository(apiClient: authRepo.apiClient);
});

final privacyProvider =
    StateNotifierProvider<PrivacyNotifier, PrivacyState>((ref) {
  final repository = ref.watch(privacyRepositoryProvider);
  return PrivacyNotifier(repository);
});

class PrivacyNotifier extends StateNotifier<PrivacyState> {
  final PrivacyRepository _repository;

  PrivacyNotifier(this._repository) : super(PrivacyState());

  Future<void> loadConsents() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final consents = await _repository.getConsents();
      state = state.copyWith(isLoading: false, consents: consents);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateConsent({
    required String category,
    required bool consented,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateConsent(
        category: category,
        consented: consented,
      );
      final updatedConsents = List<Map<String, dynamic>>.from(state.consents);
      final idx = updatedConsents.indexWhere((c) => c['category'] == category);
      if (idx >= 0) {
        updatedConsents[idx] = {'category': category, 'consented': consented};
      } else {
        updatedConsents.add({'category': category, 'consented': consented});
      }
      state = state.copyWith(isLoading: false, consents: updatedConsents);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> requestDataExport() async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    try {
      final result = await _repository.requestDataExport();
      state = state.copyWith(
        isLoading: false,
        successMessage: result['message'] as String? ?? 'Data export requested.',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> requestAccountDeletion() async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    try {
      final result = await _repository.requestAccountDeletion();
      state = state.copyWith(
        isLoading: false,
        successMessage: result['message'] as String? ?? 'Account deletion requested.',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSuccess() {
    state = state.copyWith(successMessage: null);
  }
}
