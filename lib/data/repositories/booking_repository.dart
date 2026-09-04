import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class BookingRepository {
  final ApiClient _apiClient;

  BookingRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<Service>> getServices() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/booking/services');
    final services = response['services'] as List<dynamic>? ?? [];
    return services
        .map((e) => Service.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getAvailability(
    String serviceId,
    DateTime date,
  ) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/booking/services/$serviceId/availability',
      queryParameters: {'date': date.toIso8601String()},
    );
    final slots = response['slots'] as List<dynamic>? ?? [];
    return slots.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/booking/bookings',
      data: data,
    );
    return response;
  }

  Future<List<Map<String, dynamic>>> getBookings({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/booking/bookings',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    final bookings = response['bookings'] as List<dynamic>? ?? [];
    return bookings.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> cancelBooking(String id, {String? reason}) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/booking/bookings/$id/cancel',
    );
    return response;
  }
}
