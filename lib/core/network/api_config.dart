class ApiConfig {
  static const String productionBaseUrl = 'https://api.relaxedandrefresh.com/api/v1';
  static const String stagingBaseUrl = 'http://localhost:8000/api/v1';

  static String get baseUrl {
    const env = String.fromEnvironment('ENV', defaultValue: 'production');
    switch (env) {
      case 'staging':
        return stagingBaseUrl;
      case 'production':
      default:
        return productionBaseUrl;
    }
  }

  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  ApiConfig._();

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
