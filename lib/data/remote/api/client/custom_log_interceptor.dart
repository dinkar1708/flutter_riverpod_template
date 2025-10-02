import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CustomLoggerInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('API.................... onError()');
    debugPrint('Error Url: ${err.requestOptions.uri}');
    debugPrint('Error trace: ${err.stackTrace}');
    debugPrint('Response Error: ${err.response?.data}');
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('API.................... onRequest() - Sending network request');
    debugPrint('URL: ${options.baseUrl}${options.path}');
    debugPrint('Headers: ${options.headers}');
    debugPrint('Query paramters: ${options.queryParameters}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'API.................... onResponse() - Got response - RESPONSE:'
      'Status Code: ${response.statusCode}'
      'URL: ${response.requestOptions.baseUrl}${response.requestOptions.path} \n'
      'Response Data: ${response.data}',
    );
    return handler.next(response);
  }
}
