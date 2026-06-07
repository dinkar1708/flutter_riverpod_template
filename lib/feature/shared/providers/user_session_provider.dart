import 'package:riverpod/riverpod.dart';

/// Demo user session state
/// TODO: Replace with real authentication state management
/// TODO: Persist to secure storage (flutter_secure_storage)
/// TODO: Add JWT token handling
/// TODO: Add refresh token logic
class UserSession {
  final String? username;
  final String? email;
  final bool isGuest;
  final String loginMethod; // 'email', 'google', 'guest'

  const UserSession({
    this.username,
    this.email,
    this.isGuest = false,
    this.loginMethod = 'guest',
  });

  UserSession copyWith({
    String? username,
    String? email,
    bool? isGuest,
    String? loginMethod,
  }) {
    return UserSession(
      username: username ?? this.username,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      loginMethod: loginMethod ?? this.loginMethod,
    );
  }
}

/// User session notifier for demo purposes
class UserSessionNotifier extends Notifier<UserSession?> {
  @override
  UserSession? build() => null;

  void login({
    required String username,
    String? email,
    required String loginMethod,
  }) {
    state = UserSession(
      username: username,
      email: email,
      isGuest: loginMethod == 'guest',
      loginMethod: loginMethod,
    );
  }

  void logout() {
    state = null;
  }

  void updateProfile({String? username, String? email}) {
    if (state != null) {
      state = state!.copyWith(
        username: username,
        email: email,
      );
    }
  }
}

/// Global user session provider (for demo)
final userSessionProvider = NotifierProvider<UserSessionNotifier, UserSession?>(
  UserSessionNotifier.new,
);
