import 'package:dio/dio.dart';
import 'package:flutter_riverpod_template/data/app_providers/app_provider.dart';
import 'package:flutter_riverpod_template/data/local/secure_storage_service.dart';
import 'package:flutter_riverpod_template/data/remote/api/client/api_client.dart';
import 'package:flutter_riverpod_template/data/remote/api/client/auth_interceptor.dart';
import 'package:flutter_riverpod_template/data/remote/api/client/custom_log_interceptor.dart';
import 'package:flutter_riverpod_template/data/remote/api/client/error_interceptor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_provider.g.dart';

@riverpod
ApiClient apiClient(Ref ref) {
  final dio = Dio();
  final storage = ref.read(secureStorageServiceProvider);

  // Configure timeouts
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  dio.options.sendTimeout = const Duration(seconds: 30);

  // Add interceptors (order matters)
  // 1. Auth interceptor - adds auth headers and handles token refresh
  dio.interceptors.add(AuthInterceptor(storage: storage, dio: dio));
  // 2. Error interceptor - handles API errors
  dio.interceptors.add(ErrorInterceptor());
  // 3. Logger - logs requests/responses (debug only)
  dio.interceptors.add(CustomLoggerInterceptor());

  final provider = ref.read(appProvider);
  // Set API key in headers if needed
  if (provider.apiKey.isNotEmpty) {
    dio.options.headers = {'api-key': provider.apiKey};
  }

  return ApiClient(dio, baseUrl: provider.baseUrl);
}
