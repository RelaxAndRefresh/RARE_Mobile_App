import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class SupportRepository {
  final ApiClient _apiClient;

  SupportRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<SupportTicket> createTicket(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/support/tickets',
      data: data,
    );
    return SupportTicket.fromJson(response);
  }

  Future<List<SupportTicket>> getTickets({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    final response = await _apiClient.get<List<dynamic>>(
      '/support/tickets',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => SupportTicket.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SupportTicket> getTicket(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/support/tickets/$id',
    );
    return SupportTicket.fromJson(response);
  }

  Future<SupportMessage> addMessage(String ticketId, String message) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/support/tickets/$ticketId/messages',
      data: {'content': message},
    );
    return SupportMessage.fromJson(response);
  }
}
