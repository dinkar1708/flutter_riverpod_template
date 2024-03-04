enum AppEnvironment {
  development,
  staging,
  production,
}

class AppConfig {
  AppConfig({
    required this.appName,
    required this.environment,
    required this.apiBaseUrl,
    required this.appApiKey,
    this.initializeCrashlytics = true,
  });

  final String appName;
  final AppEnvironment environment;
  final String apiBaseUrl;
  final String appApiKey;
  final bool initializeCrashlytics;
}
