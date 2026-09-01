import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class CheckinRepository {
  final ApiClient _apiClient;

  CheckinRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<DailyCheckin> submitAMCheckin(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/checkin/am',
      data: {...data, 'checkin_type': 'am'},
    );
    return DailyCheckin.fromJson(response);
  }

  Future<DailyCheckin> submitPMCheckin(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/checkin/pm',
      data: {...data, 'checkin_type': 'pm'},
    );
    return DailyCheckin.fromJson(response);
  }

  Future<DailyCheckin?> getTodayCheckin() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/checkin/today',
      );
      return DailyCheckin.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<DailyCheckin> updateCheckin(String id, Map<String, dynamic> data) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/checkin/$id',
      data: data,
    );
    return DailyCheckin.fromJson(response);
  }

  Future<HydrationLog> logHydration(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/checkin/hydration',
      data: data,
    );
    return HydrationLog.fromJson(response);
  }

  Future<List<HydrationLog>> getTodayHydration() async {
    final response = await _apiClient.get<List<dynamic>>(
      '/checkin/hydration/today',
    );
    return response
        .map((e) => HydrationLog.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
