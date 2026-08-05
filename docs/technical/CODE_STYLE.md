# Code Style Guide


## Overview

This document outlines the code style conventions and best practices for this Flutter Riverpod project. Following these guidelines ensures consistency, maintainability, and readability across the codebase.

---

## Dart Style Guidelines

### General Formatting

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

```bash
# Format all Dart files
dart format .

# Check formatting without modifying
dart format --set-exit-if-changed .
```

### Naming Conventions

**Classes, Enums, Typedefs**
```dart
// ✅ Good - UpperCamelCase
class UserRepository {}
enum AppEnvironment { dev, prod }
typedef JsonMap = Map<String, dynamic>;

// ❌ Bad
class user_repository {}
enum app_environment {}
```

**Variables, Functions, Parameters**
```dart
// ✅ Good - lowerCamelCase
final String userName = 'John';
void fetchUserData() {}

// ❌ Bad
final String user_name = 'John';
void FetchUserData() {}
```

**Constants**
```dart
// ✅ Good - lowerCamelCase
const double maxWidth = 500.0;
const String apiBaseUrl = 'https://api.example.com';

// ❌ Bad - Don't use SCREAMING_CAPS
const double MAX_WIDTH = 500.0;
```

**Private Members**
```dart
// ✅ Good - Leading underscore
class MyClass {
  final String _privateField;
  void _privateMethod() {}
}
```

---

## File Organization

### File Naming

```bash
# ✅ Good - snake_case
lib/feature/login/views/login_page.dart
lib/data/repository/user_repository.dart

# ❌ Bad
lib/feature/login/views/LoginPage.dart
lib/data/repository/UserRepository.dart
```

### Import Order

Organize imports in this order:
1. Dart imports
2. Flutter imports
3. Package imports
4. Relative imports

```dart
// ✅ Good
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../widgets/custom_button.dart';

// ❌ Bad - Mixed order
import '../models/user.dart';
import 'package:flutter/material.dart';
import 'dart:async';
```

### File Structure

```dart
// 1. Imports
import 'package:flutter/material.dart';

// 2. Part statements
part 'user.freezed.dart';
part 'user.g.dart';

// 3. Constants
const String kDefaultUsername = 'guest';

// 4. Main class/widget
class UserPage extends StatelessWidget {
  // ...
}

// 5. Private helpers (if needed)
String _formatName(String name) => name.trim();
```

---

## Riverpod Best Practices

### Provider Naming

```dart
// ✅ Good - Descriptive names
@riverpod
class UserRepository extends _$UserRepository {
  // ...
}

@riverpod
Future<User> fetchUser(FetchUserRef ref, String id) async {
  // ...
}

// Generated providers are automatically named:
// userRepositoryProvider
// fetchUserProvider
```

### Provider Organization

```dart
// ✅ Good - Group related providers
// File: lib/feature/user/providers/user_providers.dart

@riverpod
class UserRepository extends _$UserRepository {
  // Repository logic
}

@riverpod
Future<User> currentUser(CurrentUserRef ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getCurrentUser();
}

@riverpod
class UserListNotifier extends _$UserListNotifier {
  // List state management
}
```

### Ref Usage

```dart
// ✅ Good - Use ref.watch in build methods
@override
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(currentUserProvider);
  return user.when(
    data: (data) => Text(data.name),
    loading: () => CircularProgressIndicator(),
    error: (e, st) => Text('Error: $e'),
  );
}

// ✅ Good - Use ref.read in callbacks
onPressed: () {
  ref.read(userListNotifierProvider.notifier).addUser(newUser);
}

// ❌ Bad - Don't use ref.read in build
@override
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.read(currentUserProvider); // Wrong!
  return Text(user.name);
}
```

---

## Widget Best Practices

### Widget Extraction

```dart
// ✅ Good - Extract complex widgets
class UserListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userListProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: users.when(
        data: (data) => UserList(users: data),
        loading: () => LoadingIndicator(),
        error: (e, st) => ErrorView(error: e),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  final List<User> users;
  const UserList({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) => UserListItem(user: users[index]),
    );
  }
}

// ❌ Bad - Nested widgets in build method
class UserListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(users[index].name),
              subtitle: Text(users[index].email),
              // ... 50 more lines
            ),
          );
        },
      ),
    );
  }
}
```

### Const Constructors

```dart
// ✅ Good - Use const when possible
const Text('Hello')
const SizedBox(height: 16)
const EdgeInsets.all(8)

// ✅ Good - Mark widgets const
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Static content');
  }
}
```

---

## Code Documentation

### Class Documentation

```dart
/// Repository for managing user data.
///
/// Provides methods to fetch, create, and update user information
/// from the remote API.
///
/// Example:
/// ```dart
/// final repo = ref.read(userRepositoryProvider);
/// final user = await repo.fetchUser('123');
/// ```
class UserRepository {
  // ...
}
```

### Function Documentation

```dart
/// Fetches a user by their unique identifier.
///
/// Returns a [User] object if found.
/// Throws [UserNotFoundException] if user doesn't exist.
/// Throws [NetworkException] if network request fails.
Future<User> fetchUser(String id) async {
  // ...
}
```

### Inline Comments

```dart
// ✅ Good - Explain "why", not "what"
// Retry failed requests due to intermittent network issues
final response = await _retryRequest(request);

// Cache the result to avoid repeated API calls
_cache[userId] = user;

// ❌ Bad - Obvious comments
// Set the name variable to the user's name
final name = user.name;

// Create a list of users
final users = <User>[];
```

---

## Error Handling

### Try-Catch Blocks

```dart
// ✅ Good - Specific error handling
Future<User> fetchUser(String id) async {
  try {
    final response = await _api.getUser(id);
    return User.fromJson(response.data);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      throw UserNotFoundException(id);
    }
    throw NetworkException(e.message);
  } catch (e) {
    throw UnexpectedErrorException(e.toString());
  }
}

// ❌ Bad - Generic error swallowing
Future<User?> fetchUser(String id) async {
  try {
    return await _api.getUser(id);
  } catch (e) {
    return null; // Lost error information!
  }
}
```

### AsyncValue Error Handling

```dart
// ✅ Good - Proper AsyncValue error display
return asyncValue.when(
  data: (data) => DataView(data: data),
  loading: () => const LoadingIndicator(),
  error: (error, stackTrace) {
    debugPrint('Error: $error\n$stackTrace');
    return ErrorView(
      message: error.toString(),
      onRetry: () => ref.refresh(dataProvider),
    );
  },
);
```

---

## Testing Conventions

### Test Naming

```dart
// ✅ Good - Descriptive test names
test('should return user when API call succeeds', () {
  // ...
});

test('should throw NetworkException when API returns 500', () {
  // ...
});

group('UserRepository', () {
  group('fetchUser', () {
    test('should cache user after successful fetch', () {
      // ...
    });
  });
});

// ❌ Bad - Vague test names
test('test1', () {});
test('it works', () {});
```

### Test Organization

```dart
void main() {
  // 1. Setup
  late UserRepository repository;
  late MockApi mockApi;

  setUp(() {
    mockApi = MockApi();
    repository = UserRepository(mockApi);
  });

  // 2. Teardown (if needed)
  tearDown(() {
    // Clean up
  });

  // 3. Test groups
  group('fetchUser', () {
    test('should return user when API call succeeds', () async {
      // Arrange
      when(mockApi.getUser(any))
          .thenAnswer((_) async => mockUserResponse);

      // Act
      final result = await repository.fetchUser('123');

      // Assert
      expect(result, isA<User>());
      expect(result.id, '123');
      verify(mockApi.getUser('123')).called(1);
    });
  });
}
```

---

## Performance Best Practices

### Avoid Rebuilds

```dart
// ✅ Good - Extract static widgets
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    return Column(
      children: [
        const _StaticHeader(), // Won't rebuild when counter changes
        Text('Count: $counter'),
      ],
    );
  }
}

class _StaticHeader extends StatelessWidget {
  const _StaticHeader();

  @override
  Widget build(BuildContext context) {
    return const Text('Static Header');
  }
}
```

### Efficient Lists

```dart
// ✅ Good - Use keys for list items
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return UserListItem(
      key: ValueKey(items[index].id),
      user: items[index],
    );
  },
)

// ✅ Good - Use const in list builders when possible
itemBuilder: (context, index) {
  return const SizedBox(height: 8); // Const separator
}
```

---

## Security Best Practices

### Sensitive Data

```dart
// ✅ Good - Never log sensitive data in production
if (kDebugMode) {
  debugPrint('API Key: ${EnvDev.apiKey}'); // Only in debug
}

// ❌ Bad - Logging sensitive data
print('API Key: $apiKey'); // Will appear in production logs!
```

### Input Validation

```dart
// ✅ Good - Validate user input
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Invalid email format';
  }
  return null;
}
```

---

## Analysis Options

This project uses strict lint rules. See `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - avoid_print
    - unnecessary_null_checks
    - prefer_final_fields
```

Run analyzer:
```bash
flutter analyze
```

---

## Resources

### Official Documentation
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- [Riverpod Best Practices](https://riverpod.dev/docs/concepts/modifiers/family)

### Tools
- `dart format` - Auto-format code
- `dart analyze` - Lint checking
- `dart fix --apply` - Auto-fix common issues

---

**See also:**
- [Architecture Guide](ARCHITECTURE.md)
- [Testing Guidelines](../testing/UNIT_TESTING_GUIDE.md)
- [Security Best Practices](SECURITY.md)
