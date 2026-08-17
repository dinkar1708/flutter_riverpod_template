import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod_template/core/config/env.dart';
import 'package:flutter_riverpod_template/feature/shared/app_flavour/app_config.dart';
import 'package:flutter_riverpod_template/data/remote/api/providers/user/mock_user_repository_provider.dart';
import 'package:flutter_riverpod_template/data/remote/api/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/app_flavour/shared_main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables using envied (obfuscated and secure)
  final appConfig = AppConfig(
    // just test with dev
    environment: AppEnvironment.dev,
    apiBaseUrl: EnvDev.apiBaseUrl,
    appApiKey: EnvDev.apiKey,
    googleMapsApiKey: EnvDev.googleMapsApiKey,
    launchTitle: 'Mock',
    initializeCrashlytics: false,
  );
  // different for each flavours
  final overrides = [
    // override any specific depedency needed
    // override any specific depedency needed for mock
    // override for testing with hard coded data
    userRepositoryProvider.overrideWith(
      (ref) => MockUserRepository(),
    ),
  ];
  sharedMain(overrides: overrides, appConfig);
}
