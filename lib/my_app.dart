import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_riverpod_template/feature/shared/navigation/app_router.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_theme.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({
    required this.appName,
    Key? key,
  }) : super(key: key);
  final String appName;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: widget.appName,
      // theme settings
      theme: AppThemes.appTheme(Brightness.light),
      darkTheme: AppThemes.appTheme(Brightness.dark),
      themeMode: ThemeMode.light, // TODO base on condtion chage it
      // use auto router to decide widget
      routerConfig: _appRouter.config(),
    );
  }
}