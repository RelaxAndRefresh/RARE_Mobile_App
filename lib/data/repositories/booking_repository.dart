import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class BookingRepository {
  final ApiClient _apiClient;

  BookingRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<Service>> getServices() async {
    final response = await _apiClient.get<List<dynamic>>('/booking/services');
    return response
        .map((e) => Service.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getAvailability(
    String serviceId,
    DateTime date,
  ) async {
    final response = await _apiClient.get<List<dynamic>>(
      '/booking/services/$serviceId/availability',
      queryParameters: {'date': date.toIso8601String()},
    );
    return response.cast<Map<String, dynamic>>();
  }

  Future<Booking> createBooking(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/booking/bookings',
      data: data,
    );
    return Booking.fromJson(response);
  }

  Future<List<Booking>> getBookings({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    final response = await _apiClient.get<List<dynamic>>(
      '/booking/bookings',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => Booking.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Booking> cancelBooking(String id, {String? reason}) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/booking/bookings/$id/cancel',
      data: {'reason': reason},
    );
    return Booking.fromJson(response);
  }
}
