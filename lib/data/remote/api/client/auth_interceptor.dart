import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod_template/data/local/secure_storage_service.dart';

/// Interceptor to handle authentication and token refresh
class AuthInterceptor implements Interceptor {
  final SecureStorageService _storage;
  final Dio _dio;

  AuthInterceptor({
    required SecureStorageService storage,
    required Dio dio,
  })  : _storage = storage,
        _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add auth token to request headers if available
    final token = await _storage.getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if error is 401 Unauthorized
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('🔑 Received 401 - Attempting token refresh');
      }

      // Try to refresh token
      final refreshToken = await _storage.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Attempt to refresh the token
          final newToken = await _refreshToken(refreshToken);

          if (newToken != null) {
            // Save the new token
            await _storage.saveAuthToken(newToken);

            // Retry the original request with the new token
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newToken';

            if (kDebugMode) {
              debugPrint('✅ Token refreshed successfully - Retrying request');
            }

            try {
              final cloneReq = await _dio.request(
                opts.path,
                options: Options(
                  method: opts.method,
                  headers: opts.headers,
                ),
                data: opts.data,
                queryParameters: opts.queryParameters,
              );

              return handler.resolve(cloneReq);
            } catch (e) {
              if (kDebugMode) {
                debugPrint('❌ Failed to retry request after token refresh: $e');
              }
            }
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('❌ Token refresh failed: $e');
          }

          // Refresh failed - clear tokens and require login
          await _clearTokensAndLogout();
        }
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ No refresh token available - User must login');
        }

        // No refresh token - clear any stale data
        await _clearTokensAndLogout();
      }
    }

    // Pass the error to the next handler
    handler.next(err);
  }

  /// Refresh the authentication token
  /// TODO: Replace with your actual token refresh endpoint
  Future<String?> _refreshToken(String refreshToken) async {
    try {
      // Example refresh token endpoint
      // Replace this with your actual API endpoint
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'] as String?;
        final newRefreshToken = response.data['refresh_token'] as String?;

        // Save new refresh token if provided
        if (newRefreshToken != null) {
          await _storage.saveRefreshToken(newRefreshToken);
        }

        return newAccessToken;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error refreshing token: $e');
      }
      rethrow;
    }
    return null;
  }

  /// Clear tokens and logout user
  Future<void> _clearTokensAndLogout() async {
    await _storage.clearAll();

    // TODO: Navigate to login screen or emit logout event
    // This could be done through a navigation service or event bus
    if (kDebugMode) {
      debugPrint('🚪 User logged out - tokens cleared');
    }
  }
}
