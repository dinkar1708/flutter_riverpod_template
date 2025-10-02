class ApiConfig {
  ApiConfig(this.baseUrl, {required this.apiKey});

  final String baseUrl;

  String get apiUrl => baseUrl;
  final String apiKey;
}
