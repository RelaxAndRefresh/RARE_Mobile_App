import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api_models.dart';
import '../../data/repositories/onboarding_repository.dart';
import 'auth_provider.dart';

class OnboardingState {
  final bool isLoading;
  final OnboardingProgress? progress;
  final SoftScan? softScan;
  final PrivacyConsent? privacyConsent;
  final String? error;

  OnboardingState({
    this.isLoading = false,
    this.progress,
    this.softScan,
    this.privacyConsent,
    this.error,
  });

  OnboardingState copyWith({
    bool? isLoading,
    OnboardingProgress? progress,
    SoftScan? softScan,
    PrivacyConsent? privacyConsent,
    String? error,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      softScan: softScan ?? this.softScan,
      privacyConsent: privacyConsent ?? this.privacyConsent,
      error: error,
    );
  }
}

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return OnboardingRepository(apiClient: authRepo.apiClient);
});

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return OnboardingNotifier(repository);
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingNotifier(this._repository) : super(OnboardingState());

  Future<void> loadProgress() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final progress = await _repository.getProgress();
      state = state.copyWith(isLoading: false, progress: progress);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateStep(int step, {Map<String, dynamic>? data}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final progress = await _repository.updateStep(step, data: data);
      state = state.copyWith(isLoading: false, progress: progress);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitSoftScan(Map<String, dynamic> scanData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final scan = await _repository.submitSoftScan(scanData);
      state = state.copyWith(isLoading: false, softScan: scan);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> savePrivacyConsent(Map<String, dynamic> consents) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final consent = await _repository.savePrivacyConsent(consents);
      state = state.copyWith(isLoading: false, privacyConsent: consent);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> saveCycleBaseline(Map<String, dynamic> baseline) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.saveCycleBaseline(baseline);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> connectWearable({
    required String provider,
    required String deviceId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.connectWearable(provider: provider, deviceId: deviceId);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
