import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api_models.dart';
import '../../data/repositories/skin_repository.dart';
import 'auth_provider.dart';

class SkinState {
  final bool isLoading;
  final List<SkinTimelineEntry> timeline;
  final List<SkinPhoto> photos;
  final String? error;

  SkinState({
    this.isLoading = false,
    this.timeline = const [],
    this.photos = const [],
    this.error,
  });

  SkinState copyWith({
    bool? isLoading,
    List<SkinTimelineEntry>? timeline,
    List<SkinPhoto>? photos,
    String? error,
  }) {
    return SkinState(
      isLoading: isLoading ?? this.isLoading,
      timeline: timeline ?? this.timeline,
      photos: photos ?? this.photos,
      error: error,
    );
  }
}

final skinRepositoryProvider = Provider<SkinRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return SkinRepository(apiClient: authRepo.apiClient);
});

final skinProvider = StateNotifierProvider<SkinNotifier, SkinState>((ref) {
  final repository = ref.watch(skinRepositoryProvider);
  return SkinNotifier(repository);
});

class SkinNotifier extends StateNotifier<SkinState> {
  final SkinRepository _repository;

  SkinNotifier(this._repository) : super(SkinState());

  Future<void> loadTimeline({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final timeline = await _repository.getTimeline(
        startDate: startDate,
        endDate: endDate,
      );
      state = state.copyWith(isLoading: false, timeline: timeline);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadPhotos() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final photos = await _repository.getPhotos();
      state = state.copyWith(isLoading: false, photos: photos);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createLog(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final log = await _repository.createLog(data);
      final entry = SkinTimelineEntry(
        date: log.createdAt,
        log: log,
      );
      state = state.copyWith(
        isLoading: false,
        timeline: [entry, ...state.timeline],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> uploadPhoto(File file) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final photo = await _repository.uploadPhoto(file);
      state = state.copyWith(
        isLoading: false,
        photos: [photo, ...state.photos],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteLog(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteLog(id);
      state = state.copyWith(
        isLoading: false,
        timeline: state.timeline.where((e) => e.log?.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
