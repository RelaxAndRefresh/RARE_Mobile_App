import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<Notification>> getNotifications({
    bool? unreadOnly,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{};
    if (unreadOnly != null) queryParams['unread_only'] = unreadOnly;
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final response = await _apiClient.get<List<dynamic>>(
      '/notifications',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => Notification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAsRead(String id) async {
    await _apiClient.put('/notifications/$id/read');
  }

  Future<int> getUnreadCount() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/notifications/unread-count',
    );
    return response['count'] as int? ?? 0;
  }
}
