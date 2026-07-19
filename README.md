# flutter_riverpod_template

A modern Flutter template project using **Riverpod 3.0** for state management.

## ⚡ Latest Updates (Riverpod 3.0 Upgrade)

This project has been **fully upgraded** to use the latest Riverpod 3.0 patterns:

✅ **Modern AsyncNotifier** - Replaces old FutureProvider patterns
✅ **Switch Pattern for AsyncValue** - Modern Dart 3 pattern matching (no more `when`/`whenData`)
✅ **ref.listen for Side Effects** - Navigation, snackbars, dialogs
✅ **Code Generation** - All providers use `@riverpod` annotation
✅ **No Custom State Classes** - Built-in `AsyncValue` handles loading/error/data
✅ **100% Type Safe** - Full type inference with code generation

**Quick Links:**
- [Counter Example](#feature-counter-without-api) - Simple Notifier pattern
- [Repository List Example](#feature-user-github-repository-list) - GET request with AsyncNotifier
- [Login Example](#feature-login-post-with-asyncnotifier) - POST request with ref.listen
- [Riverpod 3.0 Guide](#riverpod-library-guide) - Package versions & patterns

## Table of Contents
1. [Demo](#demo)
2. [User Journeys](#user-journeys)
3. [Setup](#setup)
4. [Guide to Run Code](#guide-to-run-code)
5. [Testing](#testing)
6. [API Used](#api-used-in-the-project)
7. [Features](#features)
8. [Run Configuration Guide](#run-configuration-guide)
9. [Coding Guide](#coding-guide)
10. [Release Guide](#release-guide)
11. [APIs](#apis)
12. [Riverpod Library Guide](#riverpod-library-guide)
13. [Riverpod 3.0 Migration Guide](#riverpod-30-migration-guide)
14. [FAQ](#faq)
15. [DO/DON'T](#dodont)
16. [TODOs](#todos)

## Demo

Maestro automated test run on the Android emulator (guest onboarding, home features, tabs, explore, and profile):

https://github.com/user-attachments/assets/8186cdb3-1d40-4682-94ca-8678d99daf1e

## User Journeys

**Anyone can read these docs** — no Flutter, Maestro, or Appium setup required. Each journey is a plain step-by-step guide with a verification checklist. Use them to explore the app manually, onboard new teammates, or hand flows to AI testing tools.

**Start here:** [User Journeys index](documentation/USER_JOURNEYS.md)

| # | Journey | What you'll do |
|---|---------|----------------|
| 1 | [Guest onboarding](documentation/journeys/01-guest-onboarding.md) | Open the app and continue as guest to reach the home dashboard |
| 2 | [Home features tour](documentation/journeys/02-home-features-tour.md) | Tap each home feature card and return to the dashboard |
| 3 | [Bottom tabs round trip](documentation/journeys/03-bottom-tabs.md) | Switch between Home, Explore, and Profile tabs |
| 4 | [Explore discovery](documentation/journeys/04-explore-discovery.md) | Browse trending items and open detail screens from Explore |
| 5 | [Profile & settings](documentation/journeys/05-profile-settings.md) | Review profile options and open settings from Home and Profile |

Each doc also links to its matching Maestro and Appium automated tests for developers who want to run them.

## Setup

### Prerequisites
- Flutter SDK installed - Current tested flutter SDK 3.19.6
- Android Studio / VS Code installed
- Emulator / Simulator / Physical device for testing

### Installation
- Clone project
- Run `flutter pub get`
- Generating Code - To generate the necessary code, use the following commands:

***One-time generation:***
```bash
dart run build_runner build --delete-conflicting-outputs
```

***Continuous watch:***
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Guide to Run Code

### Run configuration configuration using .launch.json file
### Mock data
- Guide: [Mocking Providers](https://riverpod.dev/docs/essentials/testing#mocking-providers)
- Use mock run configuration to use mock/hard-coded data TODO
- Use actual configuration run actual API data

## Testing

### Quick Start
Run all tests:
```bash
flutter test
```

Run specific test file:
```bash
flutter test test/login_page_test.dart
```

### Test Documentation
For detailed testing guide, including:
- Test cases and descriptions
- Coverage information
- Writing new tests
- Best practices

Please refer to: [Testing Guide](documentation/TESTING.md)

## Final after running the app
- Test iOS device of all configurations dev and prod
- <img width="400" alt="iOS Test" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/2591585f-224a-4f82-84ca-c372d3bcad51">

- Same as iOS Test for Android device

## API Used in the project

### GitHub API:
- Base URL: `https://api.github.com/`

#### Repositories by User Name
1. **Users:**
   - User Repositories: `https://api.github.com/users/:username/repos`
- Endpoint: `users/dinkar1708/repos?per_page=3`

## Screenshots

Captured automatically via Maestro on the Android emulator (`maestro test maestro/screenshots/capture_app_screenshots.yaml`).

| Screen | Preview |
|--------|---------|
| Login | <img width="200" alt="Login" src="documentation/screenshots/01_login.png" /> |
| Home | <img width="200" alt="Home dashboard" src="documentation/screenshots/02_home.png" /> |
| Repositories | <img width="200" alt="Repositories" src="documentation/screenshots/03_repositories.png" /> |
| Search Users | <img width="200" alt="Search Users" src="documentation/screenshots/04_search_users.png" /> |
| Counter | <img width="200" alt="Counter" src="documentation/screenshots/05_counter.png" /> |
| Navigation | <img width="200" alt="Auto Route navigation" src="documentation/screenshots/06_navigation.png" /> |
| Explore | <img width="200" alt="Explore tab" src="documentation/screenshots/07_explore.png" /> |
| Profile | <img width="200" alt="Profile tab" src="documentation/screenshots/08_profile.png" /> |
| Settings | <img width="200" alt="Settings" src="documentation/screenshots/09_settings.png" /> |

## Features

### Home Page
- Navigation to feature pages
- <img width="400" alt="Home Page" src="documentation/screenshots/02_home.png">


### Feature: Navigation
- [Auto Route](https://github.com/Milad-Akarie/auto_route_library?tab=readme-ov-file#tab-navigation)
- <img width="400" alt="Navigation Feature" src="documentation/screenshots/06_navigation.png">

### Feature: Counter without API

**API-TYPE: No API**

**Requirement: Maintain state without network operation**

**How to Use Riverpod in This Case:** Use modern Riverpod 3.0 Notifier pattern with `@riverpod` code generation

1. **Define Provider** (`lib/feature/counter/providers/counter_provider.dart`):

```dart
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_provider.g.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    // Initialize counter to 0
    ref.onDispose(() {
      debugPrint('Counter provider disposed');
    });
    return 0;
  }

  void increment() => state = state + 1;
  void decrement() => state > 0 ? state = state - 1 : null;
  void reset() => state = 0;
}
```

2. **Use in UI** (Modern Riverpod 3.0 pattern):

```dart
@RoutePage()
class CounterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the counter - UI rebuilds when counter changes
    final counter = ref.watch(counterProvider);

    return Scaffold(
      body: Text('Value $counter'),
      floatingActionButton: FloatingActionButton(
        // Mutate state using notifier
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Key Points:**
- ✅ Uses `ConsumerWidget` instead of `HookWidget`
- ✅ Uses `@riverpod` annotation for code generation
- ✅ State management via `Notifier` pattern
- ✅ Clean separation: provider logic vs UI

- <img width="400" alt="Counter Feature" src="documentation/screenshots/05_counter.png">


### Feature: User GitHub Repository List

**API-TYPE: GET**

**Requirement: Fetch Data from Network**

**How to Use Riverpod in This Case:** Use modern Riverpod 3.0 `AsyncNotifier` with **switch pattern** for AsyncValue

1. **Define AsyncNotifier** (`lib/feature/repository_list/providers/repository_list_notifier_provider.dart`):

```dart
@riverpod
class RepositoryListNotifier extends _$RepositoryListNotifier {
  @override
  Future<List<RepositoryListModel>> build() async {
    // AsyncNotifier automatically handles loading/error states
    return await ref
        .read(userRepositoryProvider)
        .getRepositories(userName, pageSize);
  }
}
```

2. **Use in UI with Modern Switch Pattern**:

```dart
@RoutePage()
class RepositoryListPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<RepositoryListPage> createState() => _RepositoryListPageState();
}

class _RepositoryListPageState extends ConsumerState<RepositoryListPage> {
  @override
  Widget build(BuildContext context) {
    final repositoryListAsync = ref.watch(repositoryListProvider);

    // Modern Riverpod 3.0 switch pattern for AsyncValue
    return switch (repositoryListAsync) {
      AsyncError(:final error) => SliverFillRemaining(
          child: ErrorView(
            error: error,
            onRetry: () => ref.invalidate(repositoryListProvider),
          ),
        ),
      AsyncData(:final value) => _buildListView(value),
      _ => const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator())
        ),
    };
  }
}
```

**Key Points:**
- ✅ `AsyncNotifier` for async operations
- ✅ Modern **switch pattern** (not `when`/`whenData`)
- ✅ Pattern matching with destructuring: `AsyncData(:final value)`
- ✅ Built-in loading/error/data states via `AsyncValue`

- <img width="400" alt="Repository List" src="documentation/screenshots/03_repositories.png">


### Feature: Search Users and Handle widget local state

**API-TYPE: GET**

**Requirement: Fetch Data from Network and handle widget local state(clear button in search box)**

**How to Use Riverpod in This Case:** User Future Provider with hooks - https://riverpod.dev/docs/essentials/side_effects#going-further-showing-a-spinner--error-handling

1. Define a future and perform a network call:

```dart
// TODO later
```

2. Define parent class:

```dart
// see parent class is StatefulHookConsumerWidget which is special using via 'hooks_riverpod' library
// task 1 can use useState     final isSearchingNotifier = useState(false);

// task 2 can do read and watch -     final usersListAsync = ref.watch(usersNotifierProviderProvider);

class UsersPage extends StatefulHookConsumerWidget {
````

3. Use notifier provider on UI

// use widget local state variable
```dart
final isSearchingNotifier = useState(false);
// Change the value
        onChanged: (value) {
          isSearchingNotifier.value = true;
        },
```

```dart
// load user list data
    final usersListAsync = ref.watch(usersNotifierProviderProvider);
    return switch (usersListAsync) {
      AsyncError(:final error) => SliverToBoxAdapter(
          child: SliverToBoxAdapter(child: Text('Error $error'))),
      AsyncData(:final value) => _buildListView(value),
      _ => const SliverToBoxAdapter(child: Center(child: Text('Loading...'))),
    };
```
- <img width="400" alt="Search Users" src="documentation/screenshots/04_search_users.png">


### Feature: Login (POST with AsyncNotifier)

**API-TYPE: POST**

**Requirement: Send data to network and handle loading/error states**

**How to Use Riverpod in This Case:** Use modern Riverpod 3.0 `AsyncNotifier` with **switch pattern** + `ref.listen` for side effects

1. **Define AsyncNotifier** (`lib/feature/login/providers/login_notifier_provider.dart`):

```dart
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  Future<LoginResponseModel?> build() async {
    // Return null initially (not logged in)
    return null;
  }

  Future<void> login(LoginRequestModel request) async {
    // Set loading state - AsyncValue handles this automatically
    state = const AsyncLoading();

    try {
      // Simulated API call
      await Future.delayed(const Duration(seconds: 2));
      final loginResponse = LoginResponseModel(
        id: 1,
        userName: request.userName,
      );

      // Update state with data - AsyncValue wraps it
      state = AsyncData(loginResponse);
    } catch (error, stackTrace) {
      // AsyncValue automatically handles errors
      state = AsyncError(error, stackTrace);
    }
  }

  void logout() => state = const AsyncData(null);
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}
```

2. **Use in UI with Modern Patterns**:

```dart
@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // Listen for success/error using ref.listen for side effects
    ref.listen<AsyncValue>(loginProvider, (previous, next) {
      // Modern switch pattern for handling state changes
      switch (next) {
        case AsyncData(:final value):
          if (value != null) {
            showSnackBar(context, 'Welcome ${value.userName}!');
            context.router.replaceAll([const HomeRoute()]);
          }
        case AsyncError(:final error):
          showSnackBar(context, 'Login failed: $error');
        case AsyncLoading():
          break; // Handled in UI
      }
    });

    return Scaffold(
      body: Column(
        children: [
          // Error display using switch pattern
          _buildErrorView(),
          // Login button with loading state
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    final loginState = ref.watch(loginProvider);

    if (loginState.hasError) {
      return Container(
        child: Row(
          children: [
            Text(loginState.error.toString()),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => ref.read(loginProvider.notifier).clearError(),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoginButton() {
    final loginState = ref.watch(loginProvider);

    // Modern switch pattern for loading state
    final isLoading = switch (loginState) {
      AsyncLoading() => true,
      _ => false,
    };

    return ElevatedButton(
      onPressed: isLoading ? null : _handleLogin,
      child: isLoading
          ? const CircularProgressIndicator()
          : const Text('Sign In'),
    );
  }

  Future<void> _handleLogin() async {
    final request = LoginRequestModel(
      userName: _userNameController.text,
      password: _passwordController.text,
    );

    // Call login - state changes handled by ref.listen
    await ref.read(loginProvider.notifier).login(request);
  }
}
```

**Key Points:**
- ✅ **No custom `APIResultState`** - uses built-in `AsyncValue`
- ✅ `AsyncNotifier` for async operations
- ✅ **`ref.listen`** for side effects (navigation, snackbars)
- ✅ **Modern switch pattern** for state handling
- ✅ Clean error handling with `AsyncError`
- ✅ Loading states with `AsyncLoading`

**Loading State after the button is clicked**
- <img width="400" alt="Loading State" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/b1f458c6-b040-469e-8f8f-2a13d330f06c">

**Loaded State after the API call is done**
- <img width="400" alt="Loaded State" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/046e5e38-78b4-4968-b6f2-0b2398c3b746">


### Feature TODO: Complex Widget local state

**API-TYPE: No api**

**Requirement: Manage complext widget local state**

**How to Use Riverpod in This Case:** State notifier provider https://riverpod.dev/docs/providers/state_notifier_provider
1. Define state model class
StateModel {

}

2. Define a state notifier and define initial state:

```dart
@riverpod
class ABCNotifier extends _$ABCNotifier {
  @override
  // note here not using future
  StateModel build() async {
    return StateModel();
  }
```

3. Use notifier provider on UI

```dart
//
```

### Feature TODO: Combination of POST, GET, or Widget Local State

Define the parent `StatefulHookConsumerWidget`, which allows you to use `useState` and `ref` to access the provider in the desired manner.

**Examples:**

- **POST + Local State:** Follow the login example, but define the parent `StatefulHookConsumerWidget` to use `useState`.
  
- **POST + GET:** Follow the login example and the repository list example.
  
- **POST + GET + Widget Local State:** Follow the login example, the repository list example, and define the parent as `StatefulHookConsumerWidget` to use `useState`.

# Run Configuration Guide

## Guide link
This section provides guidance on setting up flavors, run configurations, and build modes for iOS.
- [Build Modes](https://docs.flutter.dev/testing/build-modes)
- [Flavors](https://docs.flutter.dev/deployment/flavors)

## Flavors/ Run Configuration and Build Mode Guide
Reference flavors guide - [YouTube Video](https://www.youtube.com/watch?v=GwAnn1auo8o&t=198s)
***Only the "dev" and "prod" environments follow the same steps to create a staging environment if needed. Additionally, update the same code in the main folder. Here, too, in the app_config.dart, add a new variable named staging to the AppEnvironment***

## A. iOS - Add Flavor (Schema) using Xcode

- **Add/Edit Schema:

**
  ![Add/Edit Schema](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/c8c1eeb4-107e-4d1a-a802-9215ad0756c6)

- **Change Schema Build Configuration etc.:**
  ![Change Schema Build Configuration](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/57cb00e9-9f65-4dd4-8a16-635eebb9d548)

- **Manage Schema Page:**
  ![Manage Schema Page](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/81fa6d71-e7c7-4ce1-84eb-a1988ae0b8ec)

- **Configuration:**
  In the image below, all build modes ([Debug, Profile, and Release](https://docs.flutter.dev/testing/build-modes)) have been shown for `dev` and `prod` flavors ([Flavors](https://docs.flutter.dev/deployment/flavors)).
  ![Configuration](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/07db03af-5436-4b5f-84c4-d94c2bba6dbf)

- **Fix Main File Path:**
  Go to Runner -> Target -> Build Settings -> All, search for `flutter_target`, specify value for each main file.
  ![Fix Main File Path](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/3f8cbad1-218b-4ac3-9ed2-48fd98ab7ce9)

- **Fix Display App Name:**
  Go to Runner -> Target -> Build Settings -> All, search for `product name`, specify value for each main file.
  ![Fix Display App Name](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/4ddd59b5-a435-4378-b001-d4a789594d39)

- **Fix Bundle Identifier:**
  Go to Runner -> Signing & Capability -> Build Settings -> All.
  ![Fix Bundle Identifier](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/9863da62-01e2-474f-81ab-70f7c2d0b903)

## B. Android - Add Flavor (Schema)

- Add in build.gradle (app)
  ![Add in build.gradle](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/d7964b2a-a378-4d2e-8255-5d07d42c1f8b)

## C. Use Flavor 

### Run Configuration Setting Using VS Code

Using "dev" and "prod" flavors as examples, with "Debug" and "Release" modes:

![Run configuration for dev and prod flavors](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/a7d5bbba-c77d-4c9f-b6d1-ee74bdad93e6)

![Run configuration for dev and prod flavors](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/4e0ca6c0-d373-4ed0-9ed1-14c5053412f8)

# Coding Guide
## Riverpod Guide

For detailed information on how Riverpod is used in this project, please refer to the [Features](#features) section, where each feature is accompanied by a guide based on Riverpod's functionality and requirements.

## App navigation
- follow official documentation [Auto Route](https://pub.dev/packages/auto_route)
- must run Generating Code to generate route

## Package used
**This Flutter project utilizes the following packages:**
- [Riverpod](https://riverpod.dev/docs/introduction/getting_started) - State management
- Retrofit - API call
- Dio - HTTP client
- Build Runner - Code generation
- Freezed - Code generation for models
- Freezed Annotations - Annotations for code generation

## Guide to inspect widget
**Start widget inspection. See below picture**

![Start widget inspection](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/8e0d7e6d-2ff2-40ce-b969-165fe488a6a1)

**Select mode -> Click button 'Toggle select widget mode'. See below picture**

![Toggle select widget mode](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/8d84eac2-fac1-4d33-a46e-bb0f75340ec1)

**Select widgets - Explore the widget tree to view details. Refer to the following information about the tree:. See below picture**

![Select widgets](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/f67a754b-9973-4246-9674-22b6dce165f3)

**End widget inspection. See below picture**

![End widget inspection](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/29707873-8ce6-4f0a-95cf-6f96c2aa7bdd)

# Release Guide
**Guide CI/CD For detailed guidance**
refer to: [GitHub Actions Quickstart](https://docs.github.com/en/actions/quickstart)

**Github Actions (CI/CD)**

### First-time User? Follow these steps:

1. Visit [flutter-actions/setup-flutter](https://github.com/flutter-actions/setup-flutter) and copy the provided basic version. Paste it into any file, give it a name, commit, push, and create a pull request. This action will automatically begin running.

2. If you have an extra step, add it to the .yml file:

   ```yaml
   - name: Generate code
     run: dart run build_runner build --delete-conflicting-outputs
   ```

3. Now, check if the automatic CI running has passed.

### How to Use This Repository's .yml File:
- Simply copy and paste the `build.yml` file into your repository under `.github/workflows/build.yml`, ensuring to specify the correct version of the Flutter SDK, and it will automatically start building.

# Riverpod Library Guide

## Main Packages (Riverpod 3.0)

```yaml
dependencies:
  flutter_riverpod: ^3.3.1      # Main Riverpod package
  riverpod_annotation: ^4.0.2   # Annotations for code generation
  hooks_riverpod: ^3.3.1        # Riverpod + Flutter Hooks
  riverpod: ^3.2.1              # Core Riverpod (for pure Dart)

dev_dependencies:
  riverpod_generator: ^4.0.3    # Code generator
  build_runner: ^2.4.14         # Build system
```

## Key Riverpod 3.0 Features

### 1. **Modern Notifier Pattern** (Recommended!)
- Use `@riverpod` annotation for code generation
- `Notifier` for synchronous state
- `AsyncNotifier` for asynchronous operations
- No need for manual `StateNotifier` or `ChangeNotifier`

### 2. **AsyncValue Switch Pattern** (Recommended!)
```dart
switch (asyncValue) {
  case AsyncData(:final value):
    return Text(value);
  case AsyncError(:final error):
    return Text('Error: $error');
  case AsyncLoading():
    return CircularProgressIndicator();
}
```

### 3. **ref.listen for Side Effects**
```dart
ref.listen(myProvider, (previous, next) {
  // Navigate, show snackbar, etc.
});
```

### 4. **ConsumerWidget vs HookWidget**
- **ConsumerWidget**: For Riverpod state (Recommended)
- **HookWidget**: For widget-local state (use sparingly)
- **StatefulHookConsumerWidget**: Combines both (when you need both)

# Riverpod 3.0 Migration Guide

## Old Pattern ❌ → New Pattern ✅

### 1. AsyncValue Handling

**OLD (Riverpod 2.0):**
```dart
// Using when/whenData/maybeWhen
asyncValue.when(
  data: (value) => Text(value),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);

// Or
asyncValue.whenData((data) => Text(data));
```

**NEW (Riverpod 3.0 - Switch Pattern):**
```dart
// Modern Dart 3 switch pattern with destructuring
switch (asyncValue) {
  case AsyncData(:final value):
    return Text(value);
  case AsyncError(:final error):
    return Text('Error: $error');
  case AsyncLoading():
    return CircularProgressIndicator();
}
```

### 2. Provider Definition

**OLD (Manual Provider):**
```dart
final counterProvider = StateProvider<int>((ref) => 0);
```

**NEW (Code Generation):**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state = state + 1;
}
```

### 3. Async Operations

**OLD (FutureProvider):**
```dart
final userProvider = FutureProvider<User>((ref) async {
  return await fetchUser();
});
```

**NEW (AsyncNotifier):**
```dart
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<User> build() async {
    return await fetchUser();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => fetchUser());
  }
}
```

### 4. Side Effects (Navigation, Snackbars)

**OLD (Manual state checking):**
```dart
final loginState = ref.watch(loginProvider);
if (loginState.hasValue && loginState.value != null) {
  // Navigate manually
}
```

**NEW (ref.listen):**
```dart
ref.listen(loginProvider, (previous, next) {
  switch (next) {
    case AsyncData(:final value):
      if (value != null) {
        showSnackBar(context, 'Success!');
        context.router.push(HomeRoute());
      }
    case AsyncError(:final error):
      showSnackBar(context, 'Error: $error');
  }
});
```

### 5. Custom State Models

**OLD (Custom state classes):**
```dart
class LoginStateModel {
  final APIResultState apiResultState;
  final String errorMessage;
  final User? user;
}

// In provider
state = LoginStateModel(
  apiResultState: APIResultState.loading,
  errorMessage: '',
);
```

**NEW (Use AsyncValue):**
```dart
// No custom state class needed!
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  Future<User?> build() async => null;

  Future<void> login() async {
    state = const AsyncLoading();
    try {
      final user = await api.login();
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
```

## Migration Checklist

- [ ] Update dependencies to Riverpod 3.0+
- [ ] Add `riverpod_generator` to dev_dependencies
- [ ] Replace `when`/`whenData` with `switch` pattern
- [ ] Convert manual providers to `@riverpod` annotation
- [ ] Replace `StateProvider` with `Notifier`
- [ ] Replace `FutureProvider` with `AsyncNotifier`
- [ ] Remove custom state classes, use `AsyncValue`
- [ ] Use `ref.listen` for side effects
- [ ] Run `dart run build_runner build`
- [ ] Run `flutter analyze` to verify

# APIs
For example API usage, refer to the list below:
For example API usage, refer to the [API List](documentation/API_LIST.md).

# FAQ
- Can use the `hooks_riverpod` package, StatefulHookConsumerWidget which offers HookWidget and ConsumerStatefulWidget both features.
- All pages must be suffixed by 'Page' to generate auto router automatically
Example 
Correct - HomePage  // at the end must add Page
Wrong - HomeView, HomeWidget, HomeStatefullWidget

- To resolve compile errors, follow these steps:
1. Ensure that generator dependencies are added to `pubspec.yaml` (retrofit_generator, riverpod_generator).
2. Manually delete generated files (`.g` and `.freezed.dart`) before running the build runner commands.
3. Fix compile issues (except for generated syntax) before running build runner commands again.

# DO/DON'T

## ✅ DO (Riverpod 3.0 Best Practices)

1. **DO use `@riverpod` annotation** for all providers
   ```dart
   @riverpod
   class MyNotifier extends _$MyNotifier { ... }
   ```

2. **DO use switch pattern** for AsyncValue
   ```dart
   switch (asyncValue) {
     case AsyncData(:final value): ...
     case AsyncError(:final error): ...
     case AsyncLoading(): ...
   }
   ```

3. **DO use `ref.listen`** for side effects (navigation, snackbars)
   ```dart
   ref.listen(provider, (prev, next) {
     // Handle side effects
   });
   ```

4. **DO use `ConsumerWidget`** for Riverpod state
   ```dart
   class MyWidget extends ConsumerWidget {
     Widget build(BuildContext context, WidgetRef ref) { ... }
   }
   ```

5. **DO use `AsyncNotifier`** for async operations
   ```dart
   @riverpod
   class UserNotifier extends _$UserNotifier {
     Future<User> build() async => fetchUser();
   }
   ```

6. **DO use `ref.watch`** in build method
7. **DO use `ref.read`** in event handlers (onPressed, etc.)
8. **DO run code generation** after changing providers
   ```bash
   dart run build_runner build
   ```

## ❌ DON'T (Avoid These Patterns)

1. **DON'T use `when`/`whenData`** - Use switch pattern instead
   ```dart
   // ❌ OLD
   asyncValue.when(data: ..., loading: ..., error: ...);

   // ✅ NEW
   switch (asyncValue) { ... }
   ```

2. **DON'T create custom state classes** for loading/error
   ```dart
   // ❌ DON'T
   class MyState {
     final bool isLoading;
     final String? error;
   }

   // ✅ DO - Use AsyncValue
   AsyncNotifier<MyData>
   ```

3. **DON'T use `ref.read` in build method**
   ```dart
   // ❌ DON'T
   Widget build(context, ref) {
     final value = ref.read(provider); // Wrong!
   }

   // ✅ DO
   Widget build(context, ref) {
     final value = ref.watch(provider); // Correct!
   }
   ```

4. **DON'T use StateNotifier/ChangeNotifier** - Use Notifier/AsyncNotifier
5. **DON'T forget to run build_runner** after modifying providers
6. **DON'T use HookWidget for Riverpod state** - Use ConsumerWidget

## Resources
-  [Essential Do/Don't](https://riverpod.dev/docs/essentials/do_dont)
-  [About Hooks](https://riverpod.dev/docs/concepts/about_hooks)

# Gap Analysis - What's Missing

**Reference:** [MASTER_FEATURE_SPECIFICATION.md](https://github.com/dinkar1708/github-cruise-android/blob/main/docs/master/MASTER_FEATURE_SPECIFICATION.md) - Complete feature inventory across all platforms.

## Priority 1 - Core Features Missing

| Feature ID | Feature | Priority | Status |
|------------|---------|----------|--------|
| 1.3 | User Profile Screen | P1 | TODO |
| 1.4 | Repository Details Screen | P1 | TODO |
| 2.1 | Repository Search Screen | P1 | TODO |
| 2.2 | Repository Details Screen | P1 | TODO |

**APIs Needed:**
- API-2: Get User Profile
- API-4: Search Repositories

---

## Priority 2 - Advanced Features Missing

| Feature ID | Feature | Priority | Status |
|------------|---------|----------|--------|
| 3.0 | Favorites Screen | P2 | TODO |

---

## Already Implemented (Flutter Complete)

| Feature ID | Feature | Status |
|------------|---------|--------|
| 1.1 | Splash Screen | Done |
| 1.2 | User Search Screen | Done |
| 1.5 | User Repository List Screen | Done |
| 4.0 | Settings Screen | Done |

**APIs Implemented:**
- API-1: Search Users
- API-3: Get User Repositories

---

## Additional TODOs

- [ ] Fix command line run: `flutter run --flavor development`
- [ ] Implement comprehensive unit tests (coverage goal: 70%+)
- [ ] Implement UI tests (Maestro for all journeys)
- [ ] Add CI/CD pipeline (GitHub Actions)