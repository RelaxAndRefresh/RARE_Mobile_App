import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api_models.dart';
import '../../data/repositories/credits_repository.dart';
import 'auth_provider.dart';

class CreditsState {
  final bool isLoading;
  final CreditBalance? balance;
  final List<CreditTransaction> transactions;
  final String? error;

  CreditsState({
    this.isLoading = false,
    this.balance,
    this.transactions = const [],
    this.error,
  });

  CreditsState copyWith({
    bool? isLoading,
    CreditBalance? balance,
    List<CreditTransaction>? transactions,
    String? error,
  }) {
    return CreditsState(
      isLoading: isLoading ?? this.isLoading,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      error: error,
    );
  }
}

final creditsRepositoryProvider = Provider<CreditsRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return CreditsRepository(apiClient: authRepo.apiClient);
});

final creditsProvider =
    StateNotifierProvider<CreditsNotifier, CreditsState>((ref) {
  final repository = ref.watch(creditsRepositoryProvider);
  return CreditsNotifier(repository);
});

class CreditsNotifier extends StateNotifier<CreditsState> {
  final CreditsRepository _repository;

  CreditsNotifier(this._repository) : super(CreditsState());

  int get availableCredits => state.balance?.availableCredits ?? 0;

  Future<void> loadBalance() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final balance = await _repository.getBalance();
      state = state.copyWith(isLoading: false, balance: balance);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadTransactions({String? type}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final transactions = await _repository.getTransactions(type: type);
      state = state.copyWith(isLoading: false, transactions: transactions);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _repository.getBalance(),
        _repository.getTransactions(),
      ]);
      state = state.copyWith(
        isLoading: false,
        balance: results[0] as CreditBalance,
        transactions: results[1] as List<CreditTransaction>,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
