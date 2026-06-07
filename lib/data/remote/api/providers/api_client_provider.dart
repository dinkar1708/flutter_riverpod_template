import 'package:dio/dio.dart';
import 'package:flutter_riverpod_template/data/app_providers/app_provider.dart';
import 'package:flutter_riverpod_template/data/remote/api/client/api_client.dart';
import 'package:flutter_riverpod_template/data/remote/api/client/custom_log_interceptor.dart';
import 'package:flutter_riverpod_template/data/remote/api/client/error_interceptor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_provider.g.dart';

@riverpod
ApiClient apiClient(Ref ref) {
  final dio = Dio();

  // Configure timeouts
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  dio.options.sendTimeout = const Duration(seconds: 30);

  // Add interceptors (order matters - error interceptor should be first)
  dio.interceptors.add(ErrorInterceptor());
  dio.interceptors.add(CustomLoggerInterceptor());

  final provider = ref.read(appProvider);
  // dio.options.headers = {'api-key': provider.apiKey};
  return ApiClient(dio, baseUrl: provider.baseUrl);
}
