enum AppEnvironment {
  dev,
  prod,
}

class AppConfig {
  AppConfig({
    required this.launchTitle,
    required this.environment,
    required this.apiBaseUrl,
    required this.appApiKey,
    this.initializeCrashlytics = true,
  });

  final String launchTitle;
  final AppEnvironment environment;
  final String apiBaseUrl;
  final String appApiKey;
  final bool initializeCrashlytics;
}
