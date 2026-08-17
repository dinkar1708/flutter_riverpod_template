import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    this.googleMapsApiKey = '',
    this.initializeCrashlytics = true,
  });

  final String launchTitle;
  final AppEnvironment environment;
  final String apiBaseUrl;
  final String appApiKey;
  final String googleMapsApiKey;
  final bool initializeCrashlytics;
}

// Provider for AppConfig
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden');
});
