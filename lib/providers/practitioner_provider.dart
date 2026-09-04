import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/api_models.dart';
import '../data/repositories/practitioner_repository.dart';
import 'auth_provider.dart';

class PractitionerAuthState {
  final bool isLoading;
  final String? error;
  final bool isLoggedIn;

  PractitionerAuthState({
    this.isLoading = false,
    this.error,
    this.isLoggedIn = false,
  });

  PractitionerAuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
  }) {
    return PractitionerAuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class ClientSummaryState {
  final bool isLoading;
  final Map<String, dynamic>? client;
  final String? error;

  ClientSummaryState({
    this.isLoading = false,
    this.client,
    this.error,
  });

  ClientSummaryState copyWith({
    bool? isLoading,
    Map<String, dynamic>? client,
    String? error,
  }) {
    return ClientSummaryState(
      isLoading: isLoading ?? this.isLoading,
      client: client ?? this.client,
      error: error,
    );
  }
}

class TreatmentProtocolState {
  final bool isLoading;
  final Map<String, dynamic>? protocol;
  final Map<String, dynamic>? session;
  final String? error;

  TreatmentProtocolState({
    this.isLoading = false,
    this.protocol,
    this.session,
    this.error,
  });

  TreatmentProtocolState copyWith({
    bool? isLoading,
    Map<String, dynamic>? protocol,
    Map<String, dynamic>? session,
    String? error,
  }) {
    return TreatmentProtocolState(
      isLoading: isLoading ?? this.isLoading,
      protocol: protocol ?? this.protocol,
      session: session ?? this.session,
      error: error,
    );
  }
}

class PreTreatmentConsentState {
  final bool shareSkinLogs;
  final bool shareInsights;
  final bool shareRoutine;
  final bool isLoading;
  final String? error;

  PreTreatmentConsentState({
    this.shareSkinLogs = true,
    this.shareInsights = true,
    this.shareRoutine = true,
    this.isLoading = false,
    this.error,
  });

  PreTreatmentConsentState copyWith({
    bool? shareSkinLogs,
    bool? shareInsights,
    bool? shareRoutine,
    bool? isLoading,
    String? error,
  }) {
    return PreTreatmentConsentState(
      shareSkinLogs: shareSkinLogs ?? this.shareSkinLogs,
      shareInsights: shareInsights ?? this.shareInsights,
      shareRoutine: shareRoutine ?? this.shareRoutine,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final practitionerRepositoryProvider = Provider<PractitionerRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return PractitionerRepository(apiClient: authRepo.apiClient);
});

final practitionerAuthProvider =
    StateNotifierProvider<PractitionerAuthNotifier, PractitionerAuthState>(
        (ref) {
  final repository = ref.watch(practitionerRepositoryProvider);
  return PractitionerAuthNotifier(repository);
});

final clientSummaryProvider =
    StateNotifierProvider<ClientSummaryNotifier, ClientSummaryState>((ref) {
  final repository = ref.watch(practitionerRepositoryProvider);
  return ClientSummaryNotifier(repository);
});

final treatmentProtocolProvider =
    StateNotifierProvider<TreatmentProtocolNotifier, TreatmentProtocolState>(
        (ref) {
  final repository = ref.watch(practitionerRepositoryProvider);
  return TreatmentProtocolNotifier(repository);
});

final preTreatmentConsentProvider = StateNotifierProvider<
    PreTreatmentConsentNotifier, PreTreatmentConsentState>((ref) {
  return PreTreatmentConsentNotifier();
});

class PractitionerAuthNotifier extends StateNotifier<PractitionerAuthState> {
  final PractitionerRepository _repository;

  PractitionerAuthNotifier(this._repository) : super(PractitionerAuthState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.login(email: email, password: password);
      state = state.copyWith(isLoading: false, isLoggedIn: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void reset() {
    state = PractitionerAuthState();
  }
}

class ClientSummaryNotifier extends StateNotifier<ClientSummaryState> {
  final PractitionerRepository _repository;

  ClientSummaryNotifier(this._repository) : super(ClientSummaryState());

  Future<void> loadClientSummary(String clientId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final client = await _repository.getClientSummary(clientId);
      state = state.copyWith(isLoading: false, client: client);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clear() {
    state = ClientSummaryState();
  }
}

class TreatmentProtocolNotifier extends StateNotifier<TreatmentProtocolState> {
  final PractitionerRepository _repository;

  TreatmentProtocolNotifier(this._repository)
      : super(TreatmentProtocolState());

  Future<void> createSession(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _repository.createSession(data);
      state = state.copyWith(isLoading: false, session: session);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadProtocol(String sessionId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final protocol = await _repository.getProtocol(sessionId);
      state = state.copyWith(isLoading: false, protocol: protocol);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clear() {
    state = TreatmentProtocolState();
  }
}

class PreTreatmentConsentNotifier
    extends StateNotifier<PreTreatmentConsentState> {
  PreTreatmentConsentNotifier() : super(PreTreatmentConsentState());

  void toggleSkinLogs() {
    state = state.copyWith(shareSkinLogs: !state.shareSkinLogs);
  }

  void toggleInsights() {
    state = state.copyWith(shareInsights: !state.shareInsights);
  }

  void toggleRoutine() {
    state = state.copyWith(shareRoutine: !state.shareRoutine);
  }

  void reset() {
    state = PreTreatmentConsentState();
  }
}
