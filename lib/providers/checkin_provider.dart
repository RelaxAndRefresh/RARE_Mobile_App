import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api_models.dart';
import '../../data/repositories/checkin_repository.dart';
import 'auth_provider.dart';

class CheckinState {
  final bool isLoading;
  final DailyCheckin? todayCheckin;
  final List<HydrationLog> todayHydration;
  final double totalHydrationMl;
  final String? error;

  CheckinState({
    this.isLoading = false,
    this.todayCheckin,
    this.todayHydration = const [],
    this.totalHydrationMl = 0,
    this.error,
  });

  CheckinState copyWith({
    bool? isLoading,
    DailyCheckin? todayCheckin,
    List<HydrationLog>? todayHydration,
    double? totalHydrationMl,
    String? error,
  }) {
    return CheckinState(
      isLoading: isLoading ?? this.isLoading,
      todayCheckin: todayCheckin ?? this.todayCheckin,
      todayHydration: todayHydration ?? this.todayHydration,
      totalHydrationMl: totalHydrationMl ?? this.totalHydrationMl,
      error: error,
    );
  }
}

final checkinRepositoryProvider = Provider<CheckinRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return CheckinRepository(apiClient: authRepo.apiClient);
});

final checkinProvider =
    StateNotifierProvider<CheckinNotifier, CheckinState>((ref) {
  final repository = ref.watch(checkinRepositoryProvider);
  return CheckinNotifier(repository);
});

class CheckinNotifier extends StateNotifier<CheckinState> {
  final CheckinRepository _repository;

  CheckinNotifier(this._repository) : super(CheckinState());

  Future<void> loadTodayData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final checkin = await _repository.getTodayCheckin();
      final hydration = await _repository.getTodayHydration();
      final totalMl = hydration.fold<double>(
        0,
        (sum, log) => sum + log.amountMl,
      );
      state = state.copyWith(
        isLoading: false,
        todayCheckin: checkin,
        todayHydration: hydration,
        totalHydrationMl: totalMl,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitAMCheckin(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final checkin = await _repository.submitAMCheckin(data);
      state = state.copyWith(isLoading: false, todayCheckin: checkin);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitPMCheckin(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final checkin = await _repository.submitPMCheckin(data);
      state = state.copyWith(isLoading: false, todayCheckin: checkin);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateCheckin(String id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final checkin = await _repository.updateCheckin(id, data);
      state = state.copyWith(isLoading: false, todayCheckin: checkin);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logHydration(double amountMl) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final log = await _repository.logHydration({'amount_ml': amountMl});
      final updatedHydration = [...state.todayHydration, log];
      final totalMl = updatedHydration.fold<double>(
        0,
        (sum, l) => sum + l.amountMl,
      );
      state = state.copyWith(
        isLoading: false,
        todayHydration: updatedHydration,
        totalHydrationMl: totalMl,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
