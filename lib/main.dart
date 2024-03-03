import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/data/app_providers/app_provider.dart';
import 'package:flutter_riverpod_template/data/remote/api/cient/api_config.dart';
import 'package:flutter_riverpod_template/data/remote/api/providers/user/mock_user_repository_provider.dart';
import 'package:flutter_riverpod_template/data/remote/api/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod_template/data/remote/api_url_configuration.dart';
import 'package:flutter_riverpod_template/feature/shared/navigation/app_router.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_theme.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        appProvider.overrideWithValue(
          // pass similar for dev or prod
          // create multiple launch file and do setup todo :
          ApiConfig(DevBaseUrl.baseUrlDev, apiKey: DevBaseUrl.appApiKey),
        ),
        // TODO seprate using mock run configuration
        userRepositoryProvider.overrideWith(
          (ref) => MockUserRepository(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Riverpod',
      // theme settings
      theme: AppThemes.appTheme(Brightness.light),
      darkTheme: AppThemes.appTheme(Brightness.dark),
      themeMode: ThemeMode.light, // TODO base on condtion chage it
      // use auto router to decide widget
      routerConfig: _appRouter.config(),
    );
  }
}
