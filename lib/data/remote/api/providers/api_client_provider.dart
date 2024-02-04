import 'package:dio/dio.dart';
import 'package:flutter_riverpod_template/data/app_providers/app_provider.dart';
import 'package:flutter_riverpod_template/data/remote/api/cient/api_client.dart';
import 'package:flutter_riverpod_template/data/remote/api/cient/custom_log_interceptor.dart';
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
