import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api_models.dart';
import '../../data/repositories/environmental_repository.dart';
import 'auth_provider.dart';

class EnvironmentalState {
  final bool isLoading;
  final EnvironmentalData? currentData;
  final List<EnvironmentalData> history;
  final String? error;

  EnvironmentalState({
    this.isLoading = false,
    this.currentData,
    this.history = const [],
    this.error,
  });

  EnvironmentalState copyWith({
    bool? isLoading,
    EnvironmentalData? currentData,
    List<EnvironmentalData>? history,
    String? error,
  }) {
    return EnvironmentalState(
      isLoading: isLoading ?? this.isLoading,
      currentData: currentData ?? this.currentData,
      history: history ?? this.history,
      error: error,
    );
  }
}

final environmentalRepositoryProvider = Provider<EnvironmentalRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return EnvironmentalRepository(apiClient: authRepo.apiClient);
});

final environmentalProvider =
    StateNotifierProvider<EnvironmentalNotifier, EnvironmentalState>((ref) {
  final repository = ref.watch(environmentalRepositoryProvider);
  return EnvironmentalNotifier(repository);
});

class EnvironmentalNotifier extends StateNotifier<EnvironmentalState> {
  final EnvironmentalRepository _repository;

  EnvironmentalNotifier(this._repository) : super(EnvironmentalState());

  Future<void> loadCurrentData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repository.getCurrentEnvironmentalData();
      state = state.copyWith(isLoading: false, currentData: data);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final history = await _repository.getEnvironmentalHistory();
      state = state.copyWith(isLoading: false, history: history);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
