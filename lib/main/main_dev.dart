import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod_template/core/config/env.dart';
import 'package:flutter_riverpod_template/feature/shared/app_flavour/app_config.dart';
import 'package:flutter_riverpod_template/feature/shared/app_flavour/shared_main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables using envied (obfuscated and secure)
  debugPrint('🚀 DEV Environment Loaded');
  debugPrint('📍 API Base URL: ${EnvDev.apiBaseUrl}');
  debugPrint('🔧 Environment: ${EnvDev.environment}');

  final appConfig = AppConfig(
    environment: AppEnvironment.dev,
    apiBaseUrl: EnvDev.apiBaseUrl,
    appApiKey: EnvDev.apiKey,
    googleMapsApiKey: EnvDev.googleMapsApiKey,
    launchTitle: 'Dev',
    initializeCrashlytics: false,
  );
  // different for each flavours
  final overrides = [
    // override any specific depedency needed for dev
  ];
  sharedMain(overrides: overrides, appConfig);
}
