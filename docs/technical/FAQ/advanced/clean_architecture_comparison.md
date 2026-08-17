# Clean Architecture Across iOS, Android, and Flutter

## Overview

This document explains how clean architecture principles are implemented across all three projects:
1. **Flutter Riverpod Template** - Full clean architecture
2. **GitHub iOS App (SwiftUI)** - MVVM with Repository pattern
3. **GitHub Android App (Jetpack Compose)** - MVVM with Repository pattern

All three projects follow similar architectural principles with platform-specific adaptations.

## Clean Architecture Principles

### The Core Concept

```
┌─────────────────────────────────────────────────────┐
│                   Presentation Layer                 │
│              (UI, Views, ViewModels)                 │
└─────────────────────────────────────────────────────┘
                        ↓ ↑
                  Uses / Observes
                        ↓ ↑
┌─────────────────────────────────────────────────────┐
│                   Domain Layer                       │
│          (Business Logic, Use Cases, Entities)       │
└─────────────────────────────────────────────────────┘
                        ↓ ↑
                  Implements / Provides
                        ↓ ↑
┌─────────────────────────────────────────────────────┐
│                    Data Layer                        │
│        (Repositories, Data Sources, API, DB)         │
└─────────────────────────────────────────────────────┘
```

**Key Principles:**
1. **Dependency Rule**: Dependencies point inward (Presentation → Domain ← Data)
2. **Separation of Concerns**: Each layer has distinct responsibilities
3. **Testability**: Each layer can be tested independently
4. **Independence**: Business logic independent of frameworks/UI

---

## Project 1: Flutter Riverpod Template

### Architecture: Full Clean Architecture

**Layer Structure:**
```
lib/
├── core/                    # Core utilities (cross-cutting)
│   ├── router/              # Navigation
│   ├── theme/               # UI theme
│   └── utils/               # Helpers
├── data/                    # DATA LAYER
│   ├── models/              # Data models (DTOs)
│   ├── repositories/        # Repository implementations
│   ├── remote/              # API clients
│   └── local/               # Local storage
├── domain/                  # DOMAIN LAYER (if needed)
│   ├── entities/            # Business entities
│   └── usecases/            # Business logic
└── feature/                 # PRESENTATION LAYER
    └── login/
        ├── models/          # UI state models
        ├── providers/       # State management (Riverpod)
        └── views/           # UI widgets
```

### Layer Breakdown

#### 1. Presentation Layer (feature/)

**Purpose:** Display UI and handle user interactions

**Components:**
- **Views (UI)**: StatelessWidget, ConsumerWidget
- **Providers (State)**: Riverpod NotifierProvider (like ViewModels)
- **Models**: UI state models (with Freezed)

**Example:**
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

  Future<void> login() async {
    state = state.copyWith(isLoading: true);
    try {
      // Call data layer
      final repository = ref.read(authRepositoryProvider.notifier);
      await repository.login(state.email, state.password);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
    state = state.copyWith(isLoading: false);
  }
}
```

```dart
// lib/feature/login/views/login_page.dart
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginNotifierProvider);

    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: ref.read(loginNotifierProvider.notifier).updateEmail,
          ),
          ElevatedButton(
            onPressed: ref.read(loginNotifierProvider.notifier).login,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

#### 2. Data Layer (data/)

**Purpose:** Provide data from various sources

**Components:**
- **Repositories**: Coordinate data from multiple sources
- **Data Sources**: API clients, local database
- **Models**: DTOs (Data Transfer Objects)

**Example:**
```dart
// lib/data/repositories/auth_repository.dart
@riverpod
class AuthRepository extends _$AuthRepository {
  late final Dio _dio;
  late final SecureStorage _storage;

  @override
  FutureOr<void> build() {
    _dio = ref.watch(dioProvider);
    _storage = ref.watch(secureStorageProvider);
  }

  Future<User> login(String email, String password) async {
    // Remote data source
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final user = User.fromJson(response.data);

    // Local data source
    await _storage.write(key: 'auth_token', value: user.token);

    return user;
  }

  Future<User?> getCurrentUser() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) return null;

    final response = await _dio.get('/user/me');
    return User.fromJson(response.data);
  }
}
```

```dart
// lib/data/remote/api/client/api_client.dart
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final dio = Dio(BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
  ));

  dio.interceptors.add(AuthInterceptor());
  dio.interceptors.add(ErrorInterceptor());

  return dio;
}
```

#### 3. Core Layer (core/)

**Purpose:** Shared utilities and infrastructure

**Components:**
- **Router**: Navigation configuration
- **Theme**: UI styling
- **Utils**: Helper functions
- **Constants**: App-wide constants

### Data Flow Example: Login

```
┌──────────────────────────────────────────────────┐
│ 1. User enters email/password                     │
│    LoginPage (View)                               │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 2. User taps Login button                         │
│    → loginNotifier.login()                        │
│    LoginNotifier (Provider/State Management)      │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 3. Call repository                                │
│    → authRepository.login(email, password)        │
│    AuthRepository (Data Layer)                    │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 4. Make API call                                  │
│    → dio.post('/auth/login')                      │
│    Dio (Remote Data Source)                       │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 5. Save token locally                             │
│    → secureStorage.write('auth_token')            │
│    SecureStorage (Local Data Source)              │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 6. Update UI state                                │
│    → state = state.copyWith(user: user)           │
│    LoginNotifier updates LoginPage                │
└──────────────────────────────────────────────────┘
```

---

## Project 2: iOS GitHub Search App (SwiftUI)

### Architecture: MVVM with Repository Pattern

**Layer Structure:**
```
Modules/
├── Util/                    # Core utilities
│   ├── DI/                  # Dependency injection
│   ├── Logger/              # Logging
│   └── Extensions/          # Helper extensions
├── Data/                    # DATA LAYER
│   ├── Remote/
│   │   ├── Model/           # API response models
│   │   ├── Request/         # API requests
│   │   └── Repository/      # GithubRepository
│   └── Network/             # ApiClient
└── Feature/                 # PRESENTATION LAYER
    └── UI/
        ├── UserSearch/
        │   ├── ViewModel/   # UserSearchViewModel
        │   └── Views/       # UserSearchView
        ├── Home/            # Repository search
        └── Favorites/       # Favorites
```

### Layer Breakdown

#### 1. Presentation Layer (Feature/UI/)

**Purpose:** SwiftUI views and ViewModels

**Components:**
- **Views**: SwiftUI views
- **ViewModels**: @Observable classes (iOS 17+)

**Example:**
```swift
// UserSearchViewModel.swift
@MainActor
@Observable
class UserSearchViewModel {
    var users: [SearchUser] = []
    var isLoading = false
    var errorMessage: String?

    private let repository: GithubRepository

    init(repository: GithubRepository = GithubRepository()) {
        self.repository = repository
    }

    func searchUsers(query: String) async {
        guard !query.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            users = try await repository.searchUsers(query: query)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
```

```swift
// UserSearchView.swift
struct UserSearchView: View {
    @State private var viewModel = UserSearchViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                List(viewModel.users) { user in
                    NavigationLink(value: user) {
                        UserRow(user: user)
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { oldValue, newValue in
            Task {
                await viewModel.searchUsers(query: newValue)
            }
        }
    }
}
```

#### 2. Data Layer (Data/)

**Purpose:** Repository and API client

**Components:**
- **Repository**: Business logic for data operations
- **Network**: API client (URLSession)
- **Models**: Codable structs

**Example:**
```swift
// GithubRepository.swift
class GithubRepository {
    private let apiClient: ApiClient

    init(apiClient: ApiClient = ApiClient.shared) {
        self.apiClient = apiClient
    }

    func searchUsers(query: String) async throws -> [SearchUser] {
        let response: SearchUserResponse = try await apiClient.request(
            endpoint: .searchUsers(query: query)
        )
        return response.items
    }

    func fetchUserProfile(username: String) async throws -> UserProfile {
        return try await apiClient.request(
            endpoint: .userProfile(username: username)
        )
    }
}
```

```swift
// ApiClient.swift
class ApiClient {
    static let shared = ApiClient()

    func request<T: Codable>(endpoint: Endpoint) async throws -> T {
        let (data, response) = try await URLSession.shared.data(
            for: endpoint.urlRequest
        )

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
```

### Data Flow Example: User Search

```
┌──────────────────────────────────────────────────┐
│ 1. User types in search field                     │
│    UserSearchView                                 │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 2. Debounced search triggered                     │
│    → viewModel.searchUsers(query)                 │
│    UserSearchViewModel                            │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 3. Call repository                                │
│    → repository.searchUsers(query)                │
│    GithubRepository                               │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 4. Make API call                                  │
│    → apiClient.request(.searchUsers)              │
│    ApiClient + URLSession                         │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 5. Update ViewModel state                         │
│    → users = searchResults                        │
│    @Observable triggers view update               │
└──────────────────────────────────────────────────┘
```

---

## Project 3: Android GitHub Cruise (Jetpack Compose)

### Architecture: MVVM with Repository Pattern

**Layer Structure:**
```
app/src/main/java/com/jetpack/compose/github/cruise/
├── core/                    # Core utilities
│   ├── di/                  # Hilt modules
│   ├── navigation/          # NavGraph
│   └── util/                # Extensions
├── data/                    # DATA LAYER
│   ├── model/               # Data models
│   ├── remote/              # Retrofit API
│   ├── local/               # Room database
│   └── repository/          # Repository impl
└── presentation/            # PRESENTATION LAYER
    ├── home/
    │   ├── HomeViewModel    # State management
    │   └── HomeScreen       # UI (Composable)
    ├── user/
    │   └── UserViewModel
    └── detail/
        └── DetailViewModel
```

### Layer Breakdown

#### 1. Presentation Layer (presentation/)

**Purpose:** Jetpack Compose UI and ViewModels

**Components:**
- **ViewModels**: State management with StateFlow
- **Screens**: Composable functions
- **State**: UI state data classes

**Example:**
```kotlin
// HomeViewModel.kt
@HiltViewModel
class HomeViewModel @Inject constructor(
    private val repository: GithubRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow<HomeUiState>(HomeUiState.Loading)
    val uiState: StateFlow<HomeUiState> = _uiState.asStateFlow()

    fun searchRepositories(query: String) {
        viewModelScope.launch {
            _uiState.value = HomeUiState.Loading

            try {
                val repos = repository.searchRepositories(query)
                _uiState.value = HomeUiState.Success(repos)
            } catch (e: Exception) {
                _uiState.value = HomeUiState.Error(e.message ?: "Unknown error")
            }
        }
    }
}

sealed class HomeUiState {
    object Loading : HomeUiState()
    data class Success(val repos: List<Repository>) : HomeUiState()
    data class Error(val message: String) : HomeUiState()
}
```

```kotlin
// HomeScreen.kt
@Composable
fun HomeScreen(
    viewModel: HomeViewModel = hiltViewModel()
) {
    val uiState by viewModel.uiState.collectAsState()

    Scaffold(
        topBar = {
            SearchBar(
                onSearch = { query ->
                    viewModel.searchRepositories(query)
                }
            )
        }
    ) { padding ->
        when (val state = uiState) {
            is HomeUiState.Loading -> CircularProgressIndicator()
            is HomeUiState.Success -> {
                LazyColumn(modifier = Modifier.padding(padding)) {
                    items(state.repos) { repo ->
                        RepositoryCard(repo)
                    }
                }
            }
            is HomeUiState.Error -> Text("Error: ${state.message}")
        }
    }
}
```

#### 2. Data Layer (data/)

**Purpose:** Repository and data sources

**Components:**
- **Repository**: Coordinate remote/local data
- **Remote**: Retrofit API service
- **Local**: Room database
- **Models**: Data classes

**Example:**
```kotlin
// GithubRepository.kt
class GithubRepository @Inject constructor(
    private val apiService: GithubApiService,
    private val database: AppDatabase
) {
    suspend fun searchRepositories(query: String): List<Repository> {
        return try {
            // Try remote first
            val response = apiService.searchRepositories(query)
            val repos = response.items

            // Cache in database
            database.repositoryDao().insertAll(repos)

            repos
        } catch (e: Exception) {
            // Fallback to cached data
            database.repositoryDao().searchRepositories(query)
        }
    }

    suspend fun getUserProfile(username: String): UserProfile {
        return apiService.getUserProfile(username)
    }
}
```

```kotlin
// GithubApiService.kt (Retrofit)
interface GithubApiService {
    @GET("search/repositories")
    suspend fun searchRepositories(
        @Query("q") query: String
    ): SearchRepositoryResponse

    @GET("users/{username}")
    suspend fun getUserProfile(
        @Path("username") username: String
    ): UserProfile
}
```

### Data Flow Example: Repository Search

```
┌──────────────────────────────────────────────────┐
│ 1. User types in search field                     │
│    HomeScreen (Composable)                        │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 2. Search triggered                               │
│    → viewModel.searchRepositories(query)          │
│    HomeViewModel                                  │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 3. Call repository                                │
│    → repository.searchRepositories(query)         │
│    GithubRepository                               │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 4. Try remote API                                 │
│    → apiService.searchRepositories()              │
│    Retrofit + OkHttp                              │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 5. Cache results                                  │
│    → database.repositoryDao().insertAll()         │
│    Room Database                                  │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│ 6. Update UI state                                │
│    → _uiState.value = Success(repos)              │
│    StateFlow updates Composable                   │
└──────────────────────────────────────────────────┘
```

---

## Comparison: Architecture Across Projects

| Aspect | Flutter (Riverpod) | iOS (SwiftUI) | Android (Compose) |
|--------|-------------------|---------------|-------------------|
| **Pattern** | Clean Architecture | MVVM + Repository | MVVM + Repository |
| **Presentation** | Riverpod Notifier | @Observable ViewModel | Hilt ViewModel |
| **State** | Freezed models | @Published properties | StateFlow |
| **Data** | Repository Provider | Repository class | Repository class |
| **DI** | Riverpod (built-in) | Property wrapper | Hilt |
| **Network** | Dio | URLSession | Retrofit |
| **Local DB** | (not impl) | (not impl) | Room |
| **Navigation** | GoRouter | NavigationStack | Compose Navigation |

## Common Patterns Across All Projects

### 1. Repository Pattern

**All three projects use Repository pattern to:**
- Abstract data sources from business logic
- Provide clean API for data operations
- Handle caching and offline scenarios
- Centralize error handling

### 2. MVVM/Provider Pattern

**State management:**
- **Flutter**: Riverpod NotifierProvider acts as ViewModel
- **iOS**: @Observable ViewModel with SwiftUI
- **Android**: ViewModel with StateFlow/LiveData

### 3. Separation of Concerns

**Each project separates:**
- **UI Layer**: Declarative UI (Compose/SwiftUI/Flutter widgets)
- **Logic Layer**: ViewModels/Notifiers
- **Data Layer**: Repositories and data sources

### 4. Dependency Injection

**DI approach:**
- **Flutter**: Riverpod providers (compile-time safety)
- **iOS**: Property wrapper pattern for DI
- **Android**: Hilt (compile-time DI)

## Benefits of This Architecture

### 1. Testability
```dart
// Flutter - Easy to test providers
test('login updates state correctly', () {
  final container = ProviderContainer();
  final notifier = container.read(loginNotifierProvider.notifier);

  notifier.updateEmail('test@example.com');

  expect(container.read(loginNotifierProvider).email, 'test@example.com');
});
```

```swift
// iOS - Easy to test ViewModels
func testSearchUsers() async throws {
    let mockRepository = MockGithubRepository()
    let viewModel = UserSearchViewModel(repository: mockRepository)

    await viewModel.searchUsers(query: "test")

    XCTAssertEqual(viewModel.users.count, 5)
}
```

```kotlin
// Android - Easy to test ViewModels
@Test
fun `search updates UI state correctly`() = runTest {
    val mockRepository = MockGithubRepository()
    val viewModel = HomeViewModel(mockRepository)

    viewModel.searchRepositories("test")

    val state = viewModel.uiState.value
    assertTrue(state is HomeUiState.Success)
}
```

### 2. Scalability

- Easy to add new features (new feature folder)
- Clear boundaries between layers
- Reusable components

### 3. Maintainability

- Changes in one layer don't affect others
- Clear structure for new team members
- Separation of concerns

### 4. Cross-Platform Consistency

- Similar patterns across all platforms
- Easy to port features between platforms
- Shared understanding for multi-platform teams

---

## Summary

All three projects follow clean architecture principles:

1. **Separation of Concerns**: UI, Business Logic, Data are separate
2. **Dependency Rule**: Dependencies point toward business logic
3. **Repository Pattern**: Abstract data sources
4. **MVVM/Provider Pattern**: State management
5. **Testability**: Each layer independently testable
6. **Dependency Injection**: Loose coupling between components

The specific implementation varies by platform:
- **Flutter**: Full clean architecture with Riverpod
- **iOS**: MVVM with Repository, SwiftUI + @Observable
- **Android**: MVVM with Repository, Compose + Hilt

But the core principles remain the same across all three!

---

**Last Updated:** 2026-08-16
**Difficulty:** Advanced
**Projects Covered:** Flutter, iOS (SwiftUI), Android (Jetpack Compose)
