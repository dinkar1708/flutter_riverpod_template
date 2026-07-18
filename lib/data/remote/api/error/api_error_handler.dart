import 'package:dio/dio.dart';
import 'package:flutter_riverpod_template/data/remote/api/error/api_error.dart';

/// Utility class to handle and transform API errors
class ApiErrorHandler {
  /// Transforms any exception to ApiError
  static ApiError handleError(Object error, [StackTrace? stackTrace]) {
    if (error is DioException) {
      return _handleDioException(error, stackTrace);
    } else if (error is ApiError) {
      return error;
    } else {
      return ApiError(
        type: ApiErrorType.unknown,
        message: error.toString(),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Handles DioException and converts to ApiError
  static ApiError _handleDioException(
    DioException error,
    StackTrace? stackTrace,
  ) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return ApiError(
          type: ApiErrorType.timeout,
          message: 'Request timeout',
          error: error,
          stackTrace: stackTrace ?? error.stackTrace,
        );

      case DioExceptionType.connectionError:
        return ApiError(
          type: ApiErrorType.network,
          message: 'No internet connection',
          error: error,
          stackTrace: stackTrace ?? error.stackTrace,
        );

      case DioExceptionType.cancel:
        return ApiError(
          type: ApiErrorType.cancelled,
          message: 'Request cancelled',
          error: error,
          stackTrace: stackTrace ?? error.stackTrace,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error, stackTrace);

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return ApiError(
          type: ApiErrorType.unknown,
          message: error.message ?? 'Unknown error occurred',
          error: error,
          stackTrace: stackTrace ?? error.stackTrace,
        );
    }
  }

  /// Handles bad HTTP response
  static ApiError _handleBadResponse(
    DioException error,
    StackTrace? stackTrace,
  ) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    // Try to extract error message from response
    String message = 'Request failed';
    if (responseData is Map) {
      message = responseData['message'] as String? ??
          responseData['error'] as String? ??
          message;
    } else if (responseData is String) {
      message = responseData;
    }

    if (statusCode == null) {
      return ApiError(
        type: ApiErrorType.unknown,
        message: message,
        error: error,
        stackTrace: stackTrace ?? error.stackTrace,
      );
    }

    // Map status codes to error types
    final errorType = _getErrorTypeFromStatusCode(statusCode);

    return ApiError(
      type: errorType,
      message: message,
      statusCode: statusCode,
      error: error,
      stackTrace: stackTrace ?? error.stackTrace,
    );
  }

  /// Maps HTTP status code to ApiErrorType
  static ApiErrorType _getErrorTypeFromStatusCode(int statusCode) {
    if (statusCode >= 500) {
      return ApiErrorType.server;
    } else if (statusCode == 401) {
      return ApiErrorType.unauthorized;
    } else if (statusCode == 403) {
      return ApiErrorType.forbidden;
    } else if (statusCode == 404) {
      return ApiErrorType.notFound;
    } else if (statusCode >= 400 && statusCode < 500) {
      return ApiErrorType.client;
    } else {
      return ApiErrorType.unknown;
    }
  }
}
