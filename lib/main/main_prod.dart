import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod_template/core/config/env.dart';
import 'package:flutter_riverpod_template/feature/shared/app_flavour/app_config.dart';
import 'package:flutter_riverpod_template/feature/shared/app_flavour/shared_main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables using envied (obfuscated and secure)
  final appConfig = AppConfig(
    environment: AppEnvironment.prod,
    apiBaseUrl: EnvProd.apiBaseUrl,
    appApiKey: EnvProd.apiKey,
    launchTitle: 'Prod',
    initializeCrashlytics: true,
  );
  // different for each flavours
  final overrides = [
    // override any specific depedency needed for production
  ];
  sharedMain(overrides: overrides, appConfig);
}
