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

  Future<User> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/profile',
      data: data,
    );
    return User.fromJson(response);
  }

  Future<UserProfile> updateAccountDetails(Map<String, dynamic> data) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/profile/details',
      data: data,
    );
    return UserProfile.fromJson(response);
  }

  Future<UserProfile> getProfileDetails() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/profile/details');
    return UserProfile.fromJson(response);
  }
}
