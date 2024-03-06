import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/data/app_providers/app_provider.dart';
import 'package:flutter_riverpod_template/data/remote/api/cient/api_config.dart';
import 'package:flutter_riverpod_template/feature/shared/app_flavour/app_config.dart';

import 'package:flutter_riverpod_template/my_app.dart';

void sharedMain(AppConfig appConfig,
    {List<Override> overrides = const []}) async {
  await init(appConfig);

  final List<Override> allOverrides = [
    appProvider.overrideWithValue(
      ApiConfig(appConfig.apiBaseUrl, apiKey: appConfig.appApiKey),
    ),
  ];
  allOverrides.addAll(overrides);
  runApp(
    ProviderScope(
      overrides: allOverrides,
      child: MyApp(launchTitle: appConfig.launchTitle),
    ),
  );
}

Future<void> init(AppConfig appConfig) {
  debugPrint('sharedMain launch title  ${appConfig.launchTitle}');
  debugPrint('sharedMain environment  ${appConfig.environment}');
  debugPrint('sharedMain base url ${appConfig.apiBaseUrl}');
  // TODO initialize others here
  // eg. crashlitics
  // orientation
  // etc.
  return Future.value();
}
