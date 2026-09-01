import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/api_models.dart';
import '../data/repositories/support_repository.dart';
import 'auth_provider.dart';

class SupportState {
  final bool isLoading;
  final SupportTicket? submittedTicket;
  final List<SupportTicket> tickets;
  final String? error;
  final String? successMessage;

  SupportState({
    this.isLoading = false,
    this.submittedTicket,
    this.tickets = const [],
    this.error,
    this.successMessage,
  });

  SupportState copyWith({
    bool? isLoading,
    SupportTicket? submittedTicket,
    List<SupportTicket>? tickets,
    String? error,
    String? successMessage,
  }) {
    return SupportState(
      isLoading: isLoading ?? this.isLoading,
      submittedTicket: submittedTicket ?? this.submittedTicket,
      tickets: tickets ?? this.tickets,
      error: error,
      successMessage: successMessage,
    );
  }
}

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return SupportRepository(apiClient: authRepo.apiClient);
});

final supportProvider =
    StateNotifierProvider<SupportNotifier, SupportState>((ref) {
  final repository = ref.watch(supportRepositoryProvider);
  return SupportNotifier(repository);
});

class SupportNotifier extends StateNotifier<SupportState> {
  final SupportRepository _repository;

  SupportNotifier(this._repository) : super(SupportState());

  Future<void> createTicket({
    required String category,
    required String description,
  }) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    try {
      final ticket = await _repository.createTicket({
        'subject': 'Data Issue Report - $category',
        'category': category,
        'description': description,
        'priority': 'normal',
      });
      state = state.copyWith(
        isLoading: false,
        submittedTicket: ticket,
        successMessage: 'Your report has been submitted. Ticket ID: ${ticket.id}',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadTickets({String? status}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final tickets = await _repository.getTickets(status: status);
      state = state.copyWith(isLoading: false, tickets: tickets);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}
