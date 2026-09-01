import '../../core/network/api_client.dart';

class Ritual {
  final String id;
  final String title;
  final String category;
  final String? description;
  final int durationMinutes;
  final String? audioUrl;
  final String? imageUrl;
  final bool isFeatured;

  Ritual({
    required this.id,
    required this.title,
    required this.category,
    this.description,
    this.durationMinutes = 0,
    this.audioUrl,
    this.imageUrl,
    this.isFeatured = false,
  });

  factory Ritual.fromJson(Map<String, dynamic> json) {
    return Ritual(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString(),
      durationMinutes: json['duration_minutes'] ?? 0,
      audioUrl: json['audio_url']?.toString(),
      imageUrl: json['image_url']?.toString(),
      isFeatured: json['is_featured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'duration_minutes': durationMinutes,
      'audio_url': audioUrl,
      'image_url': imageUrl,
      'is_featured': isFeatured,
    };
  }
}

class RitualsRepository {
  final ApiClient _apiClient;

  RitualsRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<Ritual> getFeaturedRitual() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/rituals/featured',
    );
    return Ritual.fromJson(response);
  }

  Future<List<Ritual>> getRitualLibrary({String? category}) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;

    final response = await _apiClient.get<List<dynamic>>(
      '/rituals/library',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return response
        .map((e) => Ritual.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
