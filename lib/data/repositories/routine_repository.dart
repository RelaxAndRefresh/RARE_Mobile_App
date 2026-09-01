import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class RoutineRepository {
  final ApiClient _apiClient;

  RoutineRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<Routine>> getRoutines() async {
    final response = await _apiClient.get<List<dynamic>>('/routines');
    return response
        .map((e) => Routine.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Routine> createRoutine(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/routines',
      data: data,
    );
    return Routine.fromJson(response);
  }

  Future<Routine> updateRoutine(String id, Map<String, dynamic> data) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/routines/$id',
      data: data,
    );
    return Routine.fromJson(response);
  }

  Future<void> deleteRoutine(String id) async {
    await _apiClient.delete('/routines/$id');
  }

  Future<List<RoutineIntervention>> getInterventions() async {
    final response = await _apiClient.get<List<dynamic>>('/routines/interventions');
    return response
        .map((e) => RoutineIntervention.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Routine> toggleRoutineActive(String id, bool isActive) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/routines/$id',
      data: {'is_active': isActive},
    );
    return Routine.fromJson(response);
  }
}
