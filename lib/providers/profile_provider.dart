import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api_models.dart';
import '../../data/repositories/profile_repository.dart';
import 'auth_provider.dart';

class ProfileState {
  final bool isLoading;
  final User? user;
  final UserProfile? profile;
  final String? error;

  ProfileState({
    this.isLoading = false,
    this.user,
    this.profile,
    this.error,
  });

  ProfileState copyWith({
    bool? isLoading,
    User? user,
    UserProfile? profile,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return ProfileRepository(apiClient: authRepo.apiClient);
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository);
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(ProfileState());

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.getProfile();
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadProfileDetails() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _repository.getProfileDetails();
      state = state.copyWith(isLoading: false, profile: profile);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.updateProfile(data);
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateAccountDetails(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _repository.updateAccountDetails(data);
      state = state.copyWith(isLoading: false, profile: profile);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _repository.getProfile(),
        _repository.getProfileDetails(),
      ]);
      state = state.copyWith(
        isLoading: false,
        user: results[0] as User,
        profile: results[1] as UserProfile,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
