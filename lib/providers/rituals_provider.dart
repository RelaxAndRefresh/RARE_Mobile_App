import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/rituals_repository.dart';

class RitualsState {
  final bool isLoading;
  final Ritual? featuredRitual;
  final List<Ritual> library;
  final String? error;

  RitualsState({
    this.isLoading = false,
    this.featuredRitual,
    this.library = const [],
    this.error,
  });

  RitualsState copyWith({
    bool? isLoading,
    Ritual? featuredRitual,
    List<Ritual>? library,
    String? error,
  }) {
    return RitualsState(
      isLoading: isLoading ?? this.isLoading,
      featuredRitual: featuredRitual ?? this.featuredRitual,
      library: library ?? this.library,
      error: error,
    );
  }
}

final ritualsRepositoryProvider = Provider<RitualsRepository>((ref) {
  return RitualsRepository();
});

final ritualsProvider =
    StateNotifierProvider<RitualsNotifier, RitualsState>((ref) {
  final repository = ref.watch(ritualsRepositoryProvider);
  return RitualsNotifier(repository);
});

class RitualsNotifier extends StateNotifier<RitualsState> {
  final RitualsRepository _repository;

  RitualsNotifier(this._repository) : super(RitualsState());

  Future<void> loadFeaturedRitual() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final ritual = await _repository.getFeaturedRitual();
      state = state.copyWith(isLoading: false, featuredRitual: ritual);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadRitualLibrary({String? category}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final library = await _repository.getRitualLibrary(category: category);
      state = state.copyWith(isLoading: false, library: library);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _repository.getFeaturedRitual(),
        _repository.getRitualLibrary(),
      ]);
      state = state.copyWith(
        isLoading: false,
        featuredRitual: results[0] as Ritual,
        library: results[1] as List<Ritual>,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
