import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class CheckinRepository {
  final ApiClient _apiClient;

  CheckinRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<DailyCheckin> submitAMCheckin(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/checkins/am',
      data: {...data, 'checkin_type': 'am'},
    );
    return DailyCheckin.fromJson(response);
  }

  Future<DailyCheckin> submitPMCheckin(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/checkins/pm',
      data: {...data, 'checkin_type': 'pm'},
    );
    return DailyCheckin.fromJson(response);
  }

  Future<DailyCheckin?> getTodayCheckin() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/checkins/today',
      );
      return DailyCheckin.fromJson(response);
    } catch (e) {
      print('[DBG] getTodayCheckin THREW -> $e');
      return null;
    }
  }

  Future<DailyCheckin> updateCheckin(String id, Map<String, dynamic> data) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/checkins/$id',
      data: data,
    );
    return DailyCheckin.fromJson(response);
  }

  Future<HydrationLog> logHydration(double amountMl) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/checkins/hydration',
      data: {'volume_ml': amountMl},
    );
    return HydrationLog.fromJson(response);
  }

  Future<List<HydrationLog>> getTodayHydration() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/checkins/hydration/today',
    );
    final logs = response['logs'] as List<dynamic>? ?? [];
    return logs
        .map((e) => HydrationLog.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
