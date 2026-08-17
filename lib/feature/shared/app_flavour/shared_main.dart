import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/core/native/native_bridge.dart';
import 'package:flutter_riverpod_template/data/app_providers/app_provider.dart';
import 'package:flutter_riverpod_template/data/remote/api/client/api_config.dart';
import 'package:flutter_riverpod_template/feature/shared/app_flavour/app_config.dart';

import 'package:flutter_riverpod_template/my_app.dart';

void sharedMain(
  AppConfig appConfig, {
  List overrides = const [],
}) async {
  await init(appConfig);

  final allOverrides = [
    appProvider.overrideWithValue(
      ApiConfig(appConfig.apiBaseUrl, apiKey: appConfig.appApiKey),
    ),
    appConfigProvider.overrideWithValue(appConfig),
    ...overrides,
  ];
  runApp(
    ProviderScope(
      overrides: allOverrides.cast(),
      child: MyApp(launchTitle: appConfig.launchTitle),
    ),
  );
}

Future<void> init(AppConfig appConfig) async {
  debugPrint('sharedMain launch title  ${appConfig.launchTitle}');
  debugPrint('sharedMain environment  ${appConfig.environment}');
  debugPrint('sharedMain base url ${appConfig.apiBaseUrl}');

  // Securely pass Google Maps API Key to native layer (iOS)
  if (appConfig.googleMapsApiKey.isNotEmpty) {
    await NativeBridge.initializeGoogleMaps(appConfig.googleMapsApiKey);
  }

  // TODO initialize others here
  // eg. crashlitics
  // orientation
  // etc.
}

