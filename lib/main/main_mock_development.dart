import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/feature/shared/app_flavour/app_config.dart';

import 'package:flutter_riverpod_template/data/remote/api/providers/user/mock_user_repository_provider.dart';
import 'package:flutter_riverpod_template/data/remote/api/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod_template/data/remote/api_url_configuration.dart';
import 'package:flutter_riverpod_template/feature/shared/app_flavour/shared_main.dart';

void main() async {
  // different for each flavours
  final appConfig = AppConfig(
    environment: AppEnvironment.development,
    apiBaseUrl: DevBaseUrl.baseUrlDev,
    appApiKey: DevBaseUrl.appApiKey,
    appName: 'Mock',
    initializeCrashlytics: false,
  );
  // different for each flavours
  final List<Override> overrides = [
    // override any specific depedency needed
    // override any specific depedency needed for mock
    // override for testing with hard coded data
    userRepositoryProvider.overrideWith(
      (ref) => MockUserRepository(),
    ),
  ];
  sharedMain(overrides: overrides, appConfig);
}
