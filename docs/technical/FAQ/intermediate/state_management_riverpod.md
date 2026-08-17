# Flutter State Management with Riverpod 3.0

## Overview

Riverpod is Flutter's modern, compile-safe state management solution. Riverpod 3.0 with code generation provides type-safe, testable, and scalable state management for Flutter applications. This guide covers how state management works in this Flutter Riverpod template project.

## Why It Matters

- Most popular state management solution in Flutter (2024-2025)
- Compile-time safety prevents runtime errors
- Essential for building scalable Flutter apps
- Frequently asked in Flutter interviews
- Replaces Provider with better architecture
- Foundation for clean, testable code

## Key Concepts

### 1. What is Riverpod?

**Riverpod = Provider + Improvements:**
- Compile-time safety (no ProviderNotFoundException at runtime)
- No BuildContext required
- Better testing support
- Automatic disposal
- Code generation for type safety
- Family and autoDispose modifiers

**Evolution:**
```
setState → Provider → Riverpod 2.0 → Riverpod 3.0 (code gen)
```

### 2. Provider Types in Riverpod

#### Provider - Immutable Values
```dart
// For constants or immutable values
@riverpod
String apiBaseUrl(ApiBaseUrlRef ref) {
  return 'https://api.example.com';
}

// Usage in widget
final url = ref.watch(apiBaseUrlProvider);
```

#### StateProvider - Simple Mutable State
```dart
// For simple mutable state (counter, toggle, etc.)
final counterProvider = StateProvider<int>((ref) => 0);

// Usage
int count = ref.watch(counterProvider);
ref.read(counterProvider.notifier).state++;
```

#### FutureProvider - Async Data Loading
```dart
// For async operations that complete once
@riverpod
Future<User> currentUser(CurrentUserRef ref) async {
  final api = ref.watch(apiClientProvider);
  return await api.getCurrentUser();
}

// Usage in widget
final userAsync = ref.watch(currentUserProvider);

return userAsync.when(
  data: (user) => Text(user.name),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

#### StreamProvider - Continuous Data Streams
```dart
// For continuous data streams
@riverpod
Stream<List<Message>> messages(MessagesRef ref) {
  final api = ref.watch(apiClientProvider);
  return api.messagesStream();
}

// Usage
final messagesAsync = ref.watch(messagesProvider);
```

#### NotifierProvider - Complex State Management
```dart
// For complex state with methods (like ViewModel)
@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  int build() => 0;  // Initial state

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

// Usage
final count = ref.watch(counterNotifierProvider);
ref.read(counterNotifierProvider.notifier).increment();
```

#### AsyncNotifierProvider - Async State Management
```dart
// For async state management (like ViewModels with async operations)
@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<User> build() async {
    // Load initial data
    final api = ref.watch(apiClientProvider);
    return await api.fetchUser();
  }

  Future<void> updateName(String newName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final api = ref.watch(apiClientProvider);
      return await api.updateUserName(newName);
    });
  }
}

// Usage
final userAsync = ref.watch(userProfileProvider);
```

### 3. How This Project Uses Riverpod

**Project Structure:**
```
lib/
├── core/
│   ├── providers/         # Global providers
│   │   ├── dio_provider.dart         # Network client
│   │   └── storage_provider.dart     # Secure storage
│   └── router/
│       └── router_provider.dart      # Navigation
├── data/
│   ├── repositories/      # Data layer
│   │   └── auth_repository.dart      # @riverpod
│   └── remote/
│       └── api_client.dart           # @riverpod
└── feature/
    └── login/
        ├── providers/     # Feature providers
        │   └── login_notifier_provider.dart  # State management
        └── views/
            └── login_page.dart       # UI (uses ref.watch)
```

### 4. Provider Example from This Project

**API Client Provider:**
```dart
// lib/data/remote/api/client/api_client.dart

@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final dio = Dio(BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
  ));

  // Add interceptors
  dio.interceptors.add(AuthInterceptor());
  dio.interceptors.add(LoggingInterceptor());

  return dio;
}

// Generated code creates: dioProvider
```

**Repository Provider:**
```dart
// lib/data/repositories/auth_repository.dart

@riverpod
class AuthRepository extends _$AuthRepository {
  late final Dio _dio;

  @override
  FutureOr<void> build() {
    _dio = ref.watch(dioProvider);
  }

  Future<User> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return User.fromJson(response.data);
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }
}

// Generated: authRepositoryProvider
```

**Feature Notifier (ViewModel):**
```dart
// lib/feature/login/providers/login_notifier_provider.dart

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _LoginState;
}

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() => const LoginState();

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  Future<void> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(authRepositoryProvider.notifier);
      await repository.login(state.email, state.password);

      // Navigate to home
      ref.read(routerProvider).go('/home');
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }
}

// Generated: loginNotifierProvider
```

**UI Usage:**
```dart
// lib/feature/login/views/login_page.dart

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginNotifierProvider);
    final loginNotifier = ref.read(loginNotifierProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: loginNotifier.updateEmail,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: loginState.errorMessage,
            ),
          ),
          TextField(
            onChanged: loginNotifier.updatePassword,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: loginState.isLoading
                ? null
                : loginNotifier.login,
            child: loginState.isLoading
                ? const CircularProgressIndicator()
                : const Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### 5. Data Flow in This Project

```
┌─────────────────────────────────────────────┐
│              UI Layer (Views)                │
│         ConsumerWidget / Consumer           │
│         ref.watch() / ref.read()            │
└─────────────────────────────────────────────┘
                     ↓ ↑
                  Watch/Read
                     ↓ ↑
┌─────────────────────────────────────────────┐
│        State Management (Providers)         │
│     NotifierProvider / AsyncNotifier        │
│          LoginNotifier, UserProfile         │
└─────────────────────────────────────────────┘
                     ↓ ↑
                Call methods
                     ↓ ↑
┌─────────────────────────────────────────────┐
│        Business Logic (Repository)          │
│         AuthRepository, UserRepository      │
│            @riverpod annotations            │
└─────────────────────────────────────────────┘
                     ↓ ↑
                 API calls
                     ↓ ↑
┌─────────────────────────────────────────────┐
│          Data Sources (API Client)          │
│              Dio, ApiClient                 │
│            dioProvider (singleton)          │
└─────────────────────────────────────────────┘
```

### 6. Key Riverpod Concepts

**ref.watch() - Rebuild on Changes**
```dart
// Rebuilds widget when provider value changes
final user = ref.watch(currentUserProvider);
```

**ref.read() - One-Time Read**
```dart
// Read value once, doesn't rebuild on changes
// Use for event handlers
onPressed: () {
  ref.read(loginNotifierProvider.notifier).login();
}
```

**ref.listen() - Side Effects**
```dart
// Execute side effects when provider changes
ref.listen(loginNotifierProvider, (previous, next) {
  if (next.errorMessage != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.errorMessage!)),
    );
  }
});
```

**AutoDispose - Automatic Cleanup**
```dart
// Automatically disposed when no longer used
@riverpod
Future<User> user(UserRef ref) async {
  // Auto-disposed when widget unmounts
  return await fetchUser();
}

// Keep alive (don't dispose)
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  return Dio();  // Singleton, never disposed
}
```

**Family - Parameterized Providers**
```dart
// Provider that takes parameters
@riverpod
Future<User> userById(UserByIdRef ref, String userId) async {
  final api = ref.watch(apiClientProvider);
  return await api.fetchUser(userId);
}

// Usage
final user = ref.watch(userByIdProvider('123'));
```

### 7. State Management Patterns in This Project

**Pattern 1: Simple Form State**
```dart
@riverpod
class LoginForm extends _$LoginForm {
  @override
  LoginFormState build() => const LoginFormState();

  void updateField(String field, String value) {
    state = field == 'email'
        ? state.copyWith(email: value)
        : state.copyWith(password: value);
  }
}
```

**Pattern 2: API Data Loading**
```dart
@riverpod
Future<List<User>> users(UsersRef ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.fetchUsers();
}

// UI automatically shows loading/data/error
final usersAsync = ref.watch(usersProvider);
usersAsync.when(
  data: (users) => ListView(children: users.map(...).toList()),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

**Pattern 3: Dependent Providers**
```dart
// Provider depends on another provider
@riverpod
Future<List<Post>> userPosts(UserPostsRef ref) async {
  // Depends on currentUser
  final user = await ref.watch(currentUserProvider.future);
  final api = ref.watch(apiClientProvider);
  return await api.fetchUserPosts(user.id);
}
```

**Pattern 4: Cached Data with Refresh**
```dart
@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<User> build() async {
    return await _fetchUser();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchUser());
  }

  Future<User> _fetchUser() async {
    final api = ref.watch(apiClientProvider);
    return await api.fetchCurrentUser();
  }
}

// Usage
ElevatedButton(
  onPressed: () => ref.read(userProfileProvider.notifier).refresh(),
  child: const Text('Refresh'),
)
```

## Comparison: Riverpod vs Other Solutions

| Aspect | setState | Provider | Riverpod 3.0 |
|--------|----------|----------|--------------|
| Compile Safety | ❌ | ❌ | ✅ |
| BuildContext | Required | Required | Optional |
| Testing | Hard | Medium | Easy |
| Code Gen | ❌ | ❌ | ✅ |
| Type Safety | ❌ | Partial | ✅ |
| Global Access | ❌ | ❌ | ✅ |
| Auto Disposal | Manual | Manual | Auto |
| Learning Curve | Easy | Medium | Medium |
| Boilerplate | Low | Medium | Low (with codegen) |

## Common Patterns in This Project

### Pattern 1: ProviderScope at Root
```dart
// lib/main/main_dev.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(  // Required at app root
      child: const MyApp(),
    ),
  );
}
```

### Pattern 2: ConsumerWidget for Reactive UI
```dart
// Widgets that need to react to provider changes
class UserListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return usersAsync.when(
      data: (users) => ListView.builder(...),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

### Pattern 3: Consumer for Partial Rebuilds
```dart
// Only rebuild specific part of widget tree
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Static content'),  // Doesn't rebuild
        Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);
            return Text('Count: $count');  // Only this rebuilds
          },
        ),
      ],
    );
  }
}
```

## Best Practices from This Project

### 1. Use Code Generation
```dart
// Run this after adding @riverpod annotations
flutter pub run build_runner build --delete-conflicting-outputs

// Watch mode for development
flutter pub run build_runner watch
```

### 2. Repository Pattern for Data
```dart
// Separate data fetching from UI
@riverpod
class UserRepository extends _$UserRepository {
  // All data operations here
}

// UI just watches
final users = ref.watch(usersProvider);
```

### 3. Freezed for Immutable State
```dart
@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    required String email,
    required bool isLoading,
  }) = _LoginState;
}

// Type-safe state updates
state = state.copyWith(isLoading: true);
```

### 4. KeepAlive for Singletons
```dart
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  return Dio();  // Created once, never disposed
}
```

## Interview Questions

### Q1: What's the difference between Provider and Riverpod?
**Answer:**
- Provider requires BuildContext, Riverpod doesn't
- Riverpod has compile-time safety, Provider doesn't
- Riverpod auto-disposes, Provider requires manual disposal
- Riverpod has better testing support
- Riverpod 3.0 has code generation for type safety

### Q2: When to use ref.watch() vs ref.read()?
**Answer:**
- `ref.watch()`: Rebuilds widget when provider changes, use in build()
- `ref.read()`: One-time read, doesn't rebuild, use in event handlers
- Never use `ref.read()` in build method
- Always use `ref.watch()` for reactive updates

### Q3: What are the different provider types in Riverpod?
**Answer:**
- Provider: Immutable values
- StateProvider: Simple mutable state
- FutureProvider: Async operations
- StreamProvider: Continuous streams
- NotifierProvider: Complex state with methods
- AsyncNotifierProvider: Async state management

### Q4: How does autoDispose work?
**Answer:**
- Providers are auto-disposed when no longer watched
- Use `@riverpod` (default autoDispose)
- Use `@Riverpod(keepAlive: true)` to prevent disposal
- Good for memory management
- Singletons should use keepAlive

### Q5: What is .family modifier?
**Answer:**
- Creates parameterized providers
- Takes arguments (userId, postId, etc.)
- Returns cached value for same parameters
- Example: `userByIdProvider('123')`

### Q6: How to test Riverpod providers?
**Answer:**
```dart
test('login notifier updates email', () {
  final container = ProviderContainer();
  final notifier = container.read(loginNotifierProvider.notifier);

  notifier.updateEmail('test@example.com');

  expect(
    container.read(loginNotifierProvider).email,
    'test@example.com',
  );
});
```

### Q7: What's AsyncValue and how to use it?
**Answer:**
- Represents async state (loading, data, error)
- Use `.when()` to handle all states
- `.whenData()` for data-only handling
- Automatically manages loading/error states

### Q8: How to invalidate/refresh a provider?
**Answer:**
```dart
// Invalidate (recreate)
ref.invalidate(userProvider);

// Refresh (for AsyncNotifier)
ref.read(userProfileProvider.notifier).refresh();
```

## Related Topics

- [Freezed for Immutable Models](./freezed_models.md)
- [Clean Architecture](../../ARCHITECTURE.md)
- [Dependency Injection](./dependency_injection.md)
- [Testing Providers](../../testing/UNIT_TESTING_GUIDE.md)

## Further Reading

- [Riverpod Documentation](https://riverpod.dev/)
- [Riverpod Code Generation](https://riverpod.dev/docs/concepts/about_code_generation)
- [Flutter State Management Guide](https://docs.flutter.dev/development/data-and-backend/state-mgmt)

---

**Last Updated:** 2026-08-16
**Difficulty:** Intermediate
**Estimated Reading Time:** 30 minutes
**Prerequisites:** Flutter basics, async/await

---

## Quick Reference

```dart
// Code generation
flutter pub run build_runner build

// Simple provider
@riverpod
String apiUrl(ApiUrlRef ref) => 'https://api.example.com';

// Async provider
@riverpod
Future<User> user(UserRef ref) async {
  return await fetchUser();
}

// Notifier (ViewModel)
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
}

// Usage in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for rebuilds
    final count = ref.watch(counterProvider);

    // Read for actions
    return ElevatedButton(
      onPressed: () => ref.read(counterProvider.notifier).increment(),
      child: Text('Count: $count'),
    );
  }
}
```
