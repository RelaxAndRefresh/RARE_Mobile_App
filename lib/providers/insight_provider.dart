import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api_models.dart';
import '../../data/repositories/insight_repository.dart';
import 'auth_provider.dart';

class InsightState {
  final bool isLoading;
  final List<BiweeklyInsight> biweeklyInsights;
  final List<MonthlyInsight> monthlyInsights;
  final List<PulseFeedItem> pulseFeed;
  final String? error;

  InsightState({
    this.isLoading = false,
    this.biweeklyInsights = const [],
    this.monthlyInsights = const [],
    this.pulseFeed = const [],
    this.error,
  });

  InsightState copyWith({
    bool? isLoading,
    List<BiweeklyInsight>? biweeklyInsights,
    List<MonthlyInsight>? monthlyInsights,
    List<PulseFeedItem>? pulseFeed,
    String? error,
  }) {
    return InsightState(
      isLoading: isLoading ?? this.isLoading,
      biweeklyInsights: biweeklyInsights ?? this.biweeklyInsights,
      monthlyInsights: monthlyInsights ?? this.monthlyInsights,
      pulseFeed: pulseFeed ?? this.pulseFeed,
      error: error,
    );
  }
}

final insightRepositoryProvider = Provider<InsightRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return InsightRepository(apiClient: authRepo.apiClient);
});

final insightProvider =
    StateNotifierProvider<InsightNotifier, InsightState>((ref) {
  final repository = ref.watch(insightRepositoryProvider);
  return InsightNotifier(repository);
});

class InsightNotifier extends StateNotifier<InsightState> {
  final InsightRepository _repository;

  InsightNotifier(this._repository) : super(InsightState());

  Future<void> loadBiweeklyInsights() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final insights = await _repository.getBiweeklyInsights();
      state = state.copyWith(isLoading: false, biweeklyInsights: insights);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMonthlyInsights() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final insights = await _repository.getMonthlyInsights();
      state = state.copyWith(isLoading: false, monthlyInsights: insights);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadPulseFeed() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final feed = await _repository.getPulseFeed();
      state = state.copyWith(isLoading: false, pulseFeed: feed);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
