import '../../core/network/api_client.dart';

class LegalDocument {
  final String id;
  final String type;
  final String title;
  final String content;
  final String? lastUpdated;

  LegalDocument({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    this.lastUpdated,
  });

  factory LegalDocument.fromJson(Map<String, dynamic> json) {
    return LegalDocument(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      lastUpdated: json['last_updated']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'content': content,
      'last_updated': lastUpdated,
    };
  }
}

class LegalRepository {
  final ApiClient _apiClient;

  LegalRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<LegalDocument> getDocument(String type) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/legal/$type',
    );
    return LegalDocument.fromJson(response);
  }
}
