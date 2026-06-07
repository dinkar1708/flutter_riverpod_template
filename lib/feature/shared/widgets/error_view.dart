import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/data/remote/api/error/api_error.dart';

/// Widget to display error messages in a user-friendly way
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.error,
    this.onRetry,
    super.key,
  });

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final errorInfo = _getErrorInfo(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .error
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                errorInfo.icon,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),

            // Error Title
            Text(
              errorInfo.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Error Message
            Text(
              errorInfo.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),

            // Retry Button
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _ErrorInfo _getErrorInfo(Object error) {
    // Extract ApiError from DioException if present
    ApiError? apiError;
    if (error is DioException && error.error is ApiError) {
      apiError = error.error as ApiError;
    } else if (error is ApiError) {
      apiError = error;
    }

    if (apiError != null) {
      return _ErrorInfo(
        icon: _getIconForErrorType(apiError.type),
        title: _getTitleForErrorType(apiError.type),
        message: apiError.userMessage,
      );
    }

    // Fallback for unknown errors
    return _ErrorInfo(
      icon: Icons.error_outline,
      title: 'Oops!',
      message: 'Something went wrong. Please try again.',
    );
  }

  IconData _getIconForErrorType(ApiErrorType type) {
    switch (type) {
      case ApiErrorType.network:
        return Icons.wifi_off_rounded;
      case ApiErrorType.timeout:
        return Icons.timer_off_rounded;
      case ApiErrorType.server:
        return Icons.dns_rounded;
      case ApiErrorType.unauthorized:
        return Icons.lock_outline_rounded;
      case ApiErrorType.forbidden:
        return Icons.block_rounded;
      case ApiErrorType.notFound:
        return Icons.search_off_rounded;
      case ApiErrorType.cancelled:
        return Icons.cancel_outlined;
      case ApiErrorType.client:
      case ApiErrorType.unknown:
        return Icons.error_outline;
    }
  }

  String _getTitleForErrorType(ApiErrorType type) {
    switch (type) {
      case ApiErrorType.network:
        return 'No Connection';
      case ApiErrorType.timeout:
        return 'Request Timeout';
      case ApiErrorType.server:
        return 'Server Error';
      case ApiErrorType.unauthorized:
        return 'Unauthorized';
      case ApiErrorType.forbidden:
        return 'Access Denied';
      case ApiErrorType.notFound:
        return 'Not Found';
      case ApiErrorType.cancelled:
        return 'Cancelled';
      case ApiErrorType.client:
      case ApiErrorType.unknown:
        return 'Error';
    }
  }
}

class _ErrorInfo {
  const _ErrorInfo({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;
}
