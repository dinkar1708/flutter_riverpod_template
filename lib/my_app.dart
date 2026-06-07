import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_riverpod_template/feature/shared/navigation/app_router.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_theme.dart';

part 'my_app.g.dart';

// Theme mode provider for app-wide theme switching
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.light;

  void toggle() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({
    required this.launchTitle,
    super.key,
  });
  final String launchTitle;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final brightness = themeMode == ThemeMode.light
        ? Brightness.light
        : (themeMode == ThemeMode.dark
            ? Brightness.dark
            : MediaQuery.platformBrightnessOf(context));

    // Set system UI overlay style globally
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            brightness == Brightness.light ? Brightness.dark : Brightness.light,
        statusBarBrightness:
            brightness == Brightness.light ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF121212),
        systemNavigationBarIconBrightness:
            brightness == Brightness.light ? Brightness.dark : Brightness.light,
      ),
    );

    return MaterialApp.router(
      title: widget.launchTitle,
      debugShowCheckedModeBanner: false, // Remove debug banner
      // Professional theme settings
      theme: AppThemes.appTheme(Brightness.light),
      darkTheme: AppThemes.appTheme(Brightness.dark),
      themeMode: themeMode,
      // Use auto router for navigation
      routerConfig: _appRouter.config(),
    );
  }
}
