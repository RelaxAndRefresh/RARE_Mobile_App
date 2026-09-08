import 'dart:io';

import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class SkinRepository {
  final ApiClient _apiClient;

  SkinRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<SkinLog> createLog(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/skin/logs',
      data: data,
    );
    return SkinLog.fromJson(response);
  }

  Future<List<SkinTimelineEntry>> getTimeline({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final response = await _apiClient.get<List<dynamic>>(
      '/skin/timeline',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => SkinTimelineEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteLog(String id) async {
    await _apiClient.delete('/skin/logs/$id');
  }

  Future<SkinPhoto> uploadPhoto(File file) async {
    await _apiClient.uploadFile(
      '/skin/photos',
      filePath: file.path,
      fieldName: 'photo',
    );
    final listResponse = await _apiClient.get<List<dynamic>>('/skin/photos?limit=1');
    if (listResponse.isNotEmpty) {
      return SkinPhoto.fromJson(listResponse.first as Map<String, dynamic>);
    }
    throw Exception('Failed to upload photo');
  }

  Future<List<SkinPhoto>> getPhotos({int? limit, int? offset}) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final response = await _apiClient.get<List<dynamic>>(
      '/skin/photos',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => SkinPhoto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
