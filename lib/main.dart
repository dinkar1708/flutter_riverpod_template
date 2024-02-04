import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/data/api/api_config.dart';
import 'package:flutter_riverpod_template/data/api/api_constants.dart';
import 'package:flutter_riverpod_template/data/sharedProviders/app_provider.dart';
import 'package:flutter_riverpod_template/feature/home_page.dart';

void main() {
  runApp(
     ProviderScope(
      overrides: [
        appProvider.overrideWithValue(
          // pass similar for dev or live
          // create multiple launch file and do setup todo :
          ApiConfig(BaseUrl.baseUrlDev, apiKey: BaseUrl.appApiKey),
        )
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Riverpod',
      theme: ThemeData(
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Flutter Riverpod Template'),
    );
  }
}