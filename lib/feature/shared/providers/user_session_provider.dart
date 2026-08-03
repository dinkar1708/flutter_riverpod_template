import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod_template/data/local/secure_storage_service.dart';

part 'user_session_provider.g.dart';

/// User session state with secure storage support
class UserSession {
  final String? username;
  final String? email;
  final bool isGuest;
  final String loginMethod; // 'email', 'google', 'guest'
  final String? token; // JWT token for authenticated users

  const UserSession({
    this.username,
    this.email,
    this.isGuest = false,
    this.loginMethod = 'guest',
    this.token,
  });

  UserSession copyWith({
    String? username,
    String? email,
    bool? isGuest,
    String? loginMethod,
    String? token,
  }) {
    return UserSession(
      username: username ?? this.username,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      loginMethod: loginMethod ?? this.loginMethod,
      token: token ?? this.token,
    );
  }

  bool get isAuthenticated => !isGuest && token != null;
}

/// User session notifier with secure storage persistence
@riverpod
class UserSessionNotifier extends _$UserSessionNotifier {
  late final SecureStorageService _storage;

  @override
  Future<UserSession?> build() async {
    _storage = ref.read(secureStorageServiceProvider);

    // Try to restore session from secure storage on app start
    final isLoggedIn = await _storage.isLoggedIn();
    if (isLoggedIn) {
      final username = await _storage.getUsername();
      final email = await _storage.getEmail();
      final token = await _storage.getAuthToken();

      if (username != null) {
        return UserSession(
          username: username,
          email: email,
          isGuest: false,
          loginMethod: 'email',
          token: token,
        );
      }
    }

    return null;
  }

  /// Login with credentials and save to secure storage
  Future<void> login({
    required String username,
    String? email,
    required String loginMethod,
    String? token,
  }) async {
    final session = UserSession(
      username: username,
      email: email,
      isGuest: loginMethod == 'guest',
      loginMethod: loginMethod,
      token: token,
    );

    // Save to secure storage if not a guest
    if (!session.isGuest && token != null) {
      await _storage.saveAuthToken(token);
      await _storage.saveUserCredentials(username: username, email: email);
    }

    state = AsyncData(session);
  }

  /// Logout and clear secure storage
  Future<void> logout() async {
    await _storage.clearAll();
    state = const AsyncData(null);
  }

  /// Update user profile
  Future<void> updateProfile({String? username, String? email}) async {
    final currentState = state.value;
    if (currentState != null) {
      final updatedSession = currentState.copyWith(
        username: username,
        email: email,
      );

      // Update secure storage
      if (!updatedSession.isGuest) {
        await _storage.saveUserCredentials(
          username: username ?? currentState.username ?? '',
          email: email ?? currentState.email,
        );
      }

      state = AsyncData(updatedSession);
    }
  }

  /// Save new auth token (for token refresh)
  Future<void> saveToken(String token) async {
    await _storage.saveAuthToken(token);
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(token: token));
    }
  }

  /// Check if session is valid
  bool get isAuthenticated => state.value?.isAuthenticated ?? false;
}

