# Architecture Documentation


---

## Overview

This Flutter application follows **Clean Architecture** principles with a **feature-based** folder structure, using **Riverpod 3.0+** for state management and dependency injection.

---

## Table of Contents

1. [Architecture Layers](#architecture-layers)
2. [Project Structure](#project-structure)
3. [State Management](#state-management)
4. [Dependency Injection](#dependency-injection)
5. [Navigation](#navigation)
6. [API Integration](#api-integration)
7. [Data Flow](#data-flow)
8. [Best Practices](#best-practices)

---

## Architecture Layers

### Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, Widgets, Pages, Controllers)      │
├─────────────────────────────────────────┤
│         Application Layer               │
│  (Providers, Notifiers, State)          │
├─────────────────────────────────────────┤
│         Domain Layer                    │
│  (Models, Business Logic)               │
├─────────────────────────────────────────┤
│         Data Layer                      │
│  (Repositories, API Clients, Storage)   │
└─────────────────────────────────────────┘
```

### Layer Responsibilities

**1. Presentation Layer** (`lib/feature/*/views/`)
- **Pages/Screens** (`lib/feature/*/views/*_page.dart`): Top-level `@RoutePage()` destinations with `Scaffold`, coordinating layout and state.
- **Feature Widgets** (`lib/feature/*/views/widgets/`): Child sub-widgets used specifically by that feature (e.g. cards, list headers, badges).
- Consumes state from providers; contains no business or data fetching logic.

**2. Application Layer** (`lib/feature/*/providers/`)
- State management via Riverpod code generation (`@riverpod`).
- Orchestrates data flow between repositories and UI.
- No direct UI widget dependencies.

**3. Domain Layer** (`lib/feature/*/models/`)
- Immutable data models (`@freezed` or `json_serializable`).
- Business entities, validation rules, and helper methods.
- Framework/platform-independent.

**4. Data Layer** (`lib/data/`)
- API clients (Retrofit/Dio) and remote data sources.
- Repositories exposing clean Future/Stream contracts to providers.
- Local storage (`flutter_secure_storage`).

---

## Project Structure

```
lib/
├── core/                           # Core infrastructure & platform services
│   ├── native/                    # MethodChannel / Platform bridge
│   ├── router/                    # AutoRoute configuration & guards
│   ├── theme/                     # Material 3 typography & theme tokens
│   └── utils/                     # Global helpers, extensions, validators
│
├── data/                          # Shared data layer
│   ├── local/                     # Local secure storage & caching
│   │   └── secure_storage_service.dart
│   └── remote/                    # API integration & networking
│       ├── api/
│       │   ├── client/           # Dio & Retrofit API client
│       │   ├── error/            # Network exceptions & error parsing
│       │   └── providers/        # API client & repository providers
│       └── api_url_configuration.dart
│
├── feature/                       # Feature modules (Feature-First Architecture)
│   ├── <feature_name>/
│   │   ├── models/               # Domain data models
│   │   │   └── <feature>_model.dart
│   │   ├── providers/            # Riverpod state notifiers & controllers
│   │   │   └── <feature>_notifier_provider.dart
│   │   └── views/                # Screen entry points & child widgets
│   │       ├── <feature>_page.dart       # Main @RoutePage() screen
│   │       └── widgets/                  # Feature-specific child widgets
│   │           ├── <feature>_header.dart
│   │           └── <feature>_item_card.dart
│   │
│   ├── repository_list/          # GitHub repository list feature
│   │   ├── models/
│   │   │   └── repository_list_model.dart
│   │   ├── providers/
│   │   │   └── repository_list_notifier_provider.dart
│   │   └── views/
│   │       ├── repository_list_page.dart
│   │       └── widgets/
│   │           └── sticky_search_header_delegate.dart
│   │
│   ├── login/                     # Authentication feature
│   │   ├── models/
│   │   ├── providers/
│   │   └── views/
│   │
│   └── shared/                    # App-wide shared presentation resources
│       ├── app_flavour/          # Flavor configurations & environment entry
│       ├── providers/            # Global providers (e.g. userSessionProvider)
│       ├── utils/                # Presentation styles (AppTextStyle, AppColor)
│       └── widgets/              # Reusable global widgets (ErrorView, SharedSliverAppBar)
│
└── main/                          # Flavor entry points
    ├── main_dev.dart
    ├── main_prod.dart
    └── main_mock_development.dart
```

### Widget Placement Guide

| Widget Type | Destination Folder | Examples |
| :--- | :--- | :--- |
| **Top-Level Screen** | `lib/feature/<feature>/views/` | `repository_list_page.dart`, `login_page.dart` |
| **Feature Child Widget** | `lib/feature/<feature>/views/widgets/` | `sticky_search_header_delegate.dart`, `repository_card.dart` |
| **Shared Global Widget** | `lib/feature/shared/widgets/` | `shared_sliver_app_bar.dart`, `error_view.dart` |

---

## State Management

### Riverpod 3.0 Patterns

#### 1. Synchronous State (Notifier)

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;  // Initial state

  void increment() => state++;
  void decrement() => state > 0 ? state-- : null;
  void reset() => state = 0;
}

// Usage
ref.watch(counterProvider);          // Read state
ref.read(counterProvider.notifier).increment();  // Mutate
```

#### 2. Asynchronous State (AsyncNotifier)

```dart
@riverpod
class UserSessionNotifier extends _$UserSessionNotifier {
  @override
  Future<UserSession?> build() async {
    // Load from secure storage
    final storage = ref.read(secureStorageServiceProvider);
    final token = await storage.getAuthToken();

    if (token != null) {
      return await _validateSession(token);
    }
    return null;
  }

  Future<void> login(String username, String token) async {
    state = const AsyncLoading();

    try {
      await _storage.saveAuthToken(token);
      state = AsyncData(UserSession(username: username));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

// Usage
ref.watch(userSessionNotifierProvider).when(
  data: (session) => Text('Hello ${session?.username}'),
  loading: () => CircularProgressIndicator(),
  error: (e, _) => Text('Error: $e'),
);
```

#### 3. Functional Provider

```dart
@riverpod
ApiClient apiClient(Ref ref) {
  final config = ref.read(appProvider);
  final storage = ref.read(secureStorageServiceProvider);

  final dio = Dio();
  dio.interceptors.add(AuthInterceptor(storage: storage));

  return ApiClient(dio, baseUrl: config.baseUrl);
}

// Usage
final client = ref.read(apiClientProvider);
```

---

## Dependency Injection

### Provider Scope

All providers are scoped to `ProviderScope`:

```dart
void main() {
  runApp(
    ProviderScope(
      overrides: [
        // Override providers for testing/mocking
      ],
      child: MyApp(),
    ),
  );
}
```

### Provider Dependencies

```dart
@riverpod
class RepositoryList extends _$RepositoryList {
  @override
  Future<List<Repository>> build() async {
    // Depend on other providers
    final userSession = ref.watch(userSessionNotifierProvider);
    final apiClient = ref.read(apiClientProvider);

    final username = userSession.value?.username ?? 'google';
    return apiClient.getRepositories(username);
  }
}
```

### Provider Override (Testing)

```dart
// In tests
final container = ProviderContainer(
  overrides: [
    apiClientProvider.overrideWith((ref) => MockApiClient()),
  ],
);
```

---

## Navigation

### AutoRoute Setup

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, initial: true),
    AutoRoute(page: HomeWithTabsRoute.page),
    AutoRoute(page: ProfileRoute.page),
  ];
}
```

### Navigation Usage

```dart
// Navigate
context.router.push(ProfileRoute(userId: 123));

// Replace
context.router.replace(const LoginRoute());

// Pop
context.router.maybePop();

// Nested navigation
AutoTabsRouter(
  routes: [
    HomeRoute(),
    UsersRoute(),
    RepositoriesRoute(),
    SettingsRoute(),
  ],
)
```

---

## API Integration

### Retrofit + Dio

```dart
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/users/{username}')
  Future<UserModel> getUser(@Path() String username);

  @GET('/users/{username}/repos')
  Future<List<RepositoryModel>> getRepositories(
    @Path() String username,
    @Query('per_page') int perPage,
  );
}
```

### Interceptors

1. **AuthInterceptor** - Adds auth headers, handles token refresh
2. **ErrorInterceptor** - Transforms errors to `ApiError`
3. **LoggerInterceptor** - Logs requests/responses (debug only)

---

## Data Flow

### User Login Flow

```
┌──────────┐    1. Tap Login
│   UI     │───────────────────┐
└──────────┘                   │
                               ▼
┌──────────┐    2. Call login()
│ Provider │◄──────────────────┤
└──────────┘                   │
     │                         │
     │ 3. API Call             │
     ▼                         │
┌──────────┐                   │
│   API    │                   │
└──────────┘                   │
     │                         │
     │ 4. Save token           │
     ▼                         │
┌──────────┐                   │
│ Storage  │                   │
└──────────┘                   │
     │                         │
     │ 5. Update state         │
     ▼                         │
┌──────────┐    6. UI rebuilds │
│   UI     │◄──────────────────┘
└──────────┘
```

### Repository List Flow

```
User Session Changed
        │
        ▼
RepositoryListNotifier.build()
        │
        ├─► Watch userSessionProvider
        │
        ├─► Read username from session
        │
        ├─► Call API (apiClient.getRepositories)
        │
        ▼
Update state → UI rebuilds
```

---

## Best Practices

### 1. Feature Isolation
✅ **Do**: Keep features independent
```dart
feature/login/     # Self-contained login feature
  ├── models/
  ├── providers/
  └── views/
```

❌ **Don't**: Cross-feature dependencies (except shared/)
```dart
// Don't do this
import 'package:app/feature/login/providers/login_provider.dart';  // In users feature
```

### 2. Provider Naming

```dart
@riverpod
class UserSessionNotifier { }  // → userSessionNotifierProvider

@riverpod
ApiClient apiClient() { }      // → apiClientProvider

@riverpod
int counter() { }              // → counterProvider
```

### 3. State Immutability

```dart
// ✅ Good: Use copyWith
state = state.copyWith(count: state.count + 1);

// ❌ Bad: Mutate state
state.count++;  // Don't do this!
```

### 4. Error Handling

```dart
@override
Future<List<User>> build() async {
  try {
    return await _api.getUsers();
  } catch (e, stack) {
    // Riverpod will automatically set AsyncError
    throw ApiException(e.toString());
  }
}
```

### 5. Code Generation

Always run after changes:
```bash
dart run build_runner build
```

---

## Architecture Decisions

### Why Riverpod 3.0?
- ✅ Compile-time safety
- ✅ Better performance
- ✅ Simpler syntax with code generation
- ✅ Built-in async support

### Why Clean Architecture?
- ✅ Testability (mock any layer)
- ✅ Maintainability (clear boundaries)
- ✅ Scalability (add features easily)
- ✅ Platform independence

### Why Feature-Based Structure?
- ✅ Clear feature ownership
- ✅ Parallel development
- ✅ Easy feature toggling
- ✅ Better code organization

---

## References

- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture/)
- [Riverpod Documentation](https://riverpod.dev/)
- [AutoRoute Guide](https://pub.dev/packages/auto_route)
- [Retrofit Documentation](https://pub.dev/packages/retrofit)

---

**Next Steps:**
- [State Management Guide](STATE_MANAGEMENT.md)
- [API Integration Guide](API_INTEGRATION.md)
- [Testing Architecture](../testing/UNIT_TESTING_GUIDE.md)
