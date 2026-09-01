import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api_models.dart';
import '../../data/repositories/routine_repository.dart';
import 'auth_provider.dart';

class RoutineState {
  final bool isLoading;
  final List<Routine> routines;
  final List<RoutineIntervention> interventions;
  final String? error;

  RoutineState({
    this.isLoading = false,
    this.routines = const [],
    this.interventions = const [],
    this.error,
  });

  RoutineState copyWith({
    bool? isLoading,
    List<Routine>? routines,
    List<RoutineIntervention>? interventions,
    String? error,
  }) {
    return RoutineState(
      isLoading: isLoading ?? this.isLoading,
      routines: routines ?? this.routines,
      interventions: interventions ?? this.interventions,
      error: error,
    );
  }
}

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return RoutineRepository(apiClient: authRepo.apiClient);
});

final routineProvider =
    StateNotifierProvider<RoutineNotifier, RoutineState>((ref) {
  final repository = ref.watch(routineRepositoryProvider);
  return RoutineNotifier(repository);
});

class RoutineNotifier extends StateNotifier<RoutineState> {
  final RoutineRepository _repository;

  RoutineNotifier(this._repository) : super(RoutineState());

  Future<void> loadRoutines() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final routines = await _repository.getRoutines();
      state = state.copyWith(isLoading: false, routines: routines);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadInterventions() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final interventions = await _repository.getInterventions();
      state = state.copyWith(isLoading: false, interventions: interventions);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createRoutine(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final routine = await _repository.createRoutine(data);
      state = state.copyWith(
        isLoading: false,
        routines: [...state.routines, routine],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateRoutine(String id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final routine = await _repository.updateRoutine(id, data);
      final updatedRoutines = state.routines.map((r) {
        return r.id == id ? routine : r;
      }).toList();
      state = state.copyWith(isLoading: false, routines: updatedRoutines);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteRoutine(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteRoutine(id);
      state = state.copyWith(
        isLoading: false,
        routines: state.routines.where((r) => r.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleRoutineActive(String id, bool isActive) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final routine = await _repository.toggleRoutineActive(id, isActive);
      final updatedRoutines = state.routines.map((r) {
        return r.id == id ? routine : r;
      }).toList();
      state = state.copyWith(isLoading: false, routines: updatedRoutines);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
