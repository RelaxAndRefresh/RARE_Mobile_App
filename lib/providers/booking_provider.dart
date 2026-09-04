import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api_models.dart';
import '../../data/repositories/booking_repository.dart';
import 'auth_provider.dart';

class BookingState {
  final bool isLoading;
  final List<Service> services;
  final List<Map<String, dynamic>> bookings;
  final List<Map<String, dynamic>> availability;
  final String? error;

  BookingState({
    this.isLoading = false,
    this.services = const [],
    this.bookings = const [],
    this.availability = const [],
    this.error,
  });

  BookingState copyWith({
    bool? isLoading,
    List<Service>? services,
    List<Map<String, dynamic>>? bookings,
    List<Map<String, dynamic>>? availability,
    String? error,
  }) {
    return BookingState(
      isLoading: isLoading ?? this.isLoading,
      services: services ?? this.services,
      bookings: bookings ?? this.bookings,
      availability: availability ?? this.availability,
      error: error,
    );
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return BookingRepository(apiClient: authRepo.apiClient);
});

final bookingProvider =
    StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return BookingNotifier(repository);
});

class BookingNotifier extends StateNotifier<BookingState> {
  final BookingRepository _repository;

  BookingNotifier(this._repository) : super(BookingState());

  Future<void> loadServices() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final services = await _repository.getServices();
      state = state.copyWith(isLoading: false, services: services);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadAvailability(String serviceId, DateTime date) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final availability = await _repository.getAvailability(serviceId, date);
      state = state.copyWith(isLoading: false, availability: availability);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadBookings({String? status}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final bookings = await _repository.getBookings(status: status);
      state = state.copyWith(isLoading: false, bookings: bookings);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createBooking(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final booking = await _repository.createBooking(data);
      state = state.copyWith(
        isLoading: false,
        bookings: [booking, ...state.bookings],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> cancelBooking(String id, {String? reason}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.cancelBooking(id, reason: reason);
      final updatedBookings = state.bookings.where((b) {
        return b['id'].toString() != id;
      }).toList();
      state = state.copyWith(isLoading: false, bookings: updatedBookings);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
