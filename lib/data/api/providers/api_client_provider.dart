import 'package:dio/dio.dart';
import 'package:flutter_riverpod_template/data/api/api_client.dart';
import 'package:flutter_riverpod_template/data/api/custom_log_interceptor.dart';
import 'package:flutter_riverpod_template/data/sharedProviders/app_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_provider.g.dart';
 
@riverpod
ApiClient apiClient(ApiClientRef ref) {
  final dio = Dio();
  dio.interceptors.add(CustomLoggerInterceptor());
  final provider = ref.read(appProvider);
  // dio.options.headers = {'api-key': provider.apiKey};
  return ApiClient(dio, baseUrl: provider.baseUrl);
}
