import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod_template/data/remote/api/error/api_error.dart';
import 'package:flutter_riverpod_template/data/remote/api/error/api_error_handler.dart';

/// Interceptor to handle API errors globally
class ErrorInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Transform DioException to ApiError
    final apiError = ApiErrorHandler.handleError(err, err.stackTrace);

    // Log error in debug mode
    if (kDebugMode) {
      debugPrint('🔴 API Error: ${apiError.type}');
      debugPrint('   URL: ${err.requestOptions.uri}');
      debugPrint('   Status Code: ${apiError.statusCode}');
      debugPrint('   Message: ${apiError.message}');
      debugPrint('   User Message: ${apiError.userMessage}');
    }

    // Handle specific error types
    _handleSpecificErrors(apiError, err);

    // Reject with ApiError instead of DioException
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: apiError,
        type: err.type,
        response: err.response,
      ),
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  /// Handle specific error types (e.g., unauthorized, token refresh)
  void _handleSpecificErrors(ApiError apiError, DioException err) {
    switch (apiError.type) {
      case ApiErrorType.unauthorized:
        // TODO: Handle unauthorized - logout user or refresh token
        debugPrint('⚠️ Unauthorized access - consider implementing token refresh');
        break;
      case ApiErrorType.network:
        // TODO: Could queue requests for retry when network is back
        debugPrint('⚠️ Network error - request failed');
        break;
      default:
        break;
    }
  }
}
