import '../../core/network/api_client.dart';
import '../models/api_models.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<User> getProfile() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/profile');
    return User.fromJson(response);
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/profile',
      data: data,
    );
    return response;
  }

  Future<Map<String, dynamic>> updateAccountDetails(Map<String, dynamic> data) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/profile/details',
      data: data,
    );
    return response;
  }

  Future<Map<String, dynamic>> getProfileDetails() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/profile/details');
    return response;
  }
}
