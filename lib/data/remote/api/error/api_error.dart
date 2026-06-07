/// Enum representing different types of API errors
enum ApiErrorType {
  /// Network connectivity issues
  network,

  /// Request timeout
  timeout,

  /// Server errors (5xx)
  server,

  /// Client errors (4xx)
  client,

  /// Unauthorized (401)
  unauthorized,

  /// Forbidden (403)
  forbidden,

  /// Not found (404)
  notFound,

  /// Request cancelled
  cancelled,

  /// Unknown error
  unknown,
}

/// Model class representing an API error
class ApiError implements Exception {
  const ApiError({
    required this.type,
    required this.message,
    this.statusCode,
    this.error,
    this.stackTrace,
  });

  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final dynamic error;
  final StackTrace? stackTrace;

  /// Returns a user-friendly error message
  String get userMessage {
    switch (type) {
      case ApiErrorType.network:
        return 'No internet connection. Please check your network.';
      case ApiErrorType.timeout:
        return 'Request timed out. Please try again.';
      case ApiErrorType.server:
        return 'Server error. Please try again later.';
      case ApiErrorType.unauthorized:
        return 'Session expired. Please login again.';
      case ApiErrorType.forbidden:
        return 'Access denied. You don\'t have permission.';
      case ApiErrorType.notFound:
        return 'Resource not found.';
      case ApiErrorType.cancelled:
        return 'Request cancelled.';
      case ApiErrorType.client:
      case ApiErrorType.unknown:
        return message.isNotEmpty ? message : 'Something went wrong.';
    }
  }

  @override
  String toString() => 'ApiError(type: $type, message: $message, '
      'statusCode: $statusCode)';
}
