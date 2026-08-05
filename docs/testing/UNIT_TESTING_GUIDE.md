# Unit Testing Guide


---

## Overview

This guide covers unit testing patterns for the Flutter Riverpod Template, focusing on testing providers, business logic, and utilities without UI dependencies.

---

## Table of Contents

1. [Setup](#setup)
2. [Testing Providers](#testing-providers)
3. [Testing Notifiers](#testing-notifiers)
4. [Testing AsyncNotifiers](#testing-asyncnotifiers)
5. [Testing Utilities](#testing-utilities)
6. [Mocking Dependencies](#mocking-dependencies)
7. [Best Practices](#best-practices)
8. [Coverage Goals](#coverage-goals)

---

## Setup

### Dependencies

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

### Test File Structure

```
test/
├── unit/
│   ├── providers/
│   │   ├── counter_provider_test.dart
│   │   ├── user_session_notifier_test.dart
│   │   └── repository_list_notifier_test.dart
│   ├── services/
│   │   └── secure_storage_service_test.dart
│   └── utils/
│       └── validators_test.dart
├── widget/
│   └── ...
└── integration/
    └── ...
```

---

## Testing Providers

### Simple Provider (Synchronous)

**Provider:**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state > 0 ? state-- : null;
  void reset() => state = 0;
}
```

**Test:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/feature/counter/providers/counter_provider.dart';

void main() {
  group('Counter Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial value should be 0', () {
      final counter = container.read(counterProvider);
      expect(counter, equals(0));
    });

    test('increment increases counter by 1', () {
      final notifier = container.read(counterProvider.notifier);

      notifier.increment();
      expect(container.read(counterProvider), equals(1));

      notifier.increment();
      expect(container.read(counterProvider), equals(2));
    });

    test('decrement decreases counter by 1', () {
      final notifier = container.read(counterProvider.notifier);

      notifier.setValue(5);
      notifier.decrement();
      expect(container.read(counterProvider), equals(4));
    });

    test('decrement should not go below 0', () {
      final notifier = container.read(counterProvider.notifier);

      expect(container.read(counterProvider), equals(0));
      notifier.decrement();
      expect(container.read(counterProvider), equals(0));
    });

    test('reset sets counter to 0', () {
      final notifier = container.read(counterProvider.notifier);

      notifier.increment();
      notifier.increment();
      notifier.reset();
      expect(container.read(counterProvider), equals(0));
    });
  });

  group('Counter State Management', () {
    test('creates independent instances for different containers', () {
      final container1 = ProviderContainer();
      final container2 = ProviderContainer();

      container1.read(counterProvider.notifier).setValue(5);
      container2.read(counterProvider.notifier).setValue(10);

      expect(container1.read(counterProvider), equals(5));
      expect(container2.read(counterProvider), equals(10));

      container1.dispose();
      container2.dispose();
    });
  });
}
```

---

## Testing Notifiers

### Testing Business Logic

**Notifier:**
```dart
@riverpod
class ShoppingCart extends _$ShoppingCart {
  @override
  List<Product> build() => [];

  void addProduct(Product product) {
    state = [...state, product];
  }

  void removeProduct(String productId) {
    state = state.where((p) => p.id != productId).toList();
  }

  double get total => state.fold(0, (sum, p) => sum + p.price);
}
```

**Test:**
```dart
void main() {
  group('ShoppingCart Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial cart is empty', () {
      final cart = container.read(shoppingCartProvider);
      expect(cart, isEmpty);
    });

    test('addProduct adds item to cart', () {
      final notifier = container.read(shoppingCartProvider.notifier);
      final product = Product(id: '1', name: 'Test', price: 10.0);

      notifier.addProduct(product);

      final cart = container.read(shoppingCartProvider);
      expect(cart.length, equals(1));
      expect(cart.first.id, equals('1'));
    });

    test('removeProduct removes item from cart', () {
      final notifier = container.read(shoppingCartProvider.notifier);
      final product = Product(id: '1', name: 'Test', price: 10.0);

      notifier.addProduct(product);
      notifier.removeProduct('1');

      final cart = container.read(shoppingCartProvider);
      expect(cart, isEmpty);
    });

    test('total calculates correct sum', () {
      final notifier = container.read(shoppingCartProvider.notifier);

      notifier.addProduct(Product(id: '1', name: 'A', price: 10.0));
      notifier.addProduct(Product(id: '2', name: 'B', price: 20.0));

      expect(notifier.total, equals(30.0));
    });
  });
}
```

---

## Testing AsyncNotifiers

### Testing Async State

**AsyncNotifier:**
```dart
@riverpod
class UserSessionNotifier extends _$UserSessionNotifier {
  late final SecureStorageService _storage;

  @override
  Future<UserSession?> build() async {
    _storage = ref.read(secureStorageServiceProvider);
    final token = await _storage.getAuthToken();

    if (token != null) {
      return UserSession(username: 'user', token: token);
    }
    return null;
  }

  Future<void> login(String username, String token) async {
    state = const AsyncLoading();

    try {
      await _storage.saveAuthToken(token);
      state = AsyncData(UserSession(username: username, token: token));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
```

**Test:**
```dart
void main() {
  group('UserSessionNotifier Tests', () {
    late ProviderContainer container;
    late MockSecureStorageService mockStorage;

    setUp(() {
      mockStorage = MockSecureStorageService();
      container = ProviderContainer(
        overrides: [
          secureStorageServiceProvider.overrideWithValue(mockStorage),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('build returns null when no token stored', () async {
      when(mockStorage.getAuthToken()).thenAnswer((_) async => null);

      final session = await container.read(userSessionNotifierProvider.future);

      expect(session, isNull);
      verify(mockStorage.getAuthToken()).called(1);
    });

    test('build restores session when token exists', () async {
      when(mockStorage.getAuthToken()).thenAnswer((_) async => 'token123');

      final session = await container.read(userSessionNotifierProvider.future);

      expect(session, isNotNull);
      expect(session?.username, equals('user'));
      expect(session?.token, equals('token123'));
    });

    test('login saves token and updates state', () async {
      when(mockStorage.saveAuthToken(any)).thenAnswer((_) async => {});

      final notifier = container.read(userSessionNotifierProvider.notifier);
      await notifier.login('testuser', 'token456');

      final session = container.read(userSessionNotifierProvider).value;

      expect(session?.username, equals('testuser'));
      expect(session?.token, equals('token456'));
      verify(mockStorage.saveAuthToken('token456')).called(1);
    });

    test('login handles errors correctly', () async {
      when(mockStorage.saveAuthToken(any))
          .thenThrow(Exception('Storage error'));

      final notifier = container.read(userSessionNotifierProvider.notifier);
      await notifier.login('testuser', 'token456');

      final state = container.read(userSessionNotifierProvider);

      expect(state.hasError, isTrue);
    });
  });
}
```

---

## Testing Utilities

### Validators

**Validator:**
```dart
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }
}
```

**Test:**
```dart
void main() {
  group('Validators Tests', () {
    group('validateEmail', () {
      test('returns null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user.name@company.co.uk'), isNull);
      });

      test('returns error for empty email', () {
        expect(Validators.validateEmail(''), isNotNull);
        expect(Validators.validateEmail(null), isNotNull);
      });

      test('returns error for invalid email format', () {
        expect(Validators.validateEmail('notanemail'), isNotNull);
        expect(Validators.validateEmail('missing@domain'), isNotNull);
        expect(Validators.validateEmail('@nodomain.com'), isNotNull);
      });
    });

    group('validatePassword', () {
      test('returns null for valid password', () {
        expect(Validators.validatePassword('Password123'), isNull);
        expect(Validators.validatePassword('MyP@ss123'), isNull);
      });

      test('returns error for empty password', () {
        expect(Validators.validatePassword(''), isNotNull);
        expect(Validators.validatePassword(null), isNotNull);
      });

      test('returns error for password less than 8 characters', () {
        expect(Validators.validatePassword('Pass1'), isNotNull);
      });

      test('returns error for password without uppercase', () {
        expect(Validators.validatePassword('password123'), isNotNull);
      });

      test('returns error for password without lowercase', () {
        expect(Validators.validatePassword('PASSWORD123'), isNotNull);
      });

      test('returns error for password without number', () {
        expect(Validators.validatePassword('Password'), isNotNull);
      });
    });
  });
}
```

---

## Mocking Dependencies

### Generate Mocks with Mockito

**Setup:**
```dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks
@GenerateMocks([
  SecureStorageService,
  ApiClient,
  UserRepository,
])
import 'your_test.mocks.dart';
```

**Generate:**
```bash
dart run build_runner build
```

### Using Mocks

```dart
void main() {
  late MockApiClient mockApiClient;
  late MockUserRepository mockRepository;

  setUp(() {
    mockApiClient = MockApiClient();
    mockRepository = MockUserRepository();
  });

  test('example with mocks', () {
    // Arrange
    when(mockRepository.getUser('username'))
        .thenAnswer((_) async => User(name: 'Test User'));

    // Act
    final result = await mockRepository.getUser('username');

    // Assert
    expect(result.name, equals('Test User'));
    verify(mockRepository.getUser('username')).called(1);
  });
}
```

### Provider Overrides

```dart
test('override providers in tests', () {
  final container = ProviderContainer(
    overrides: [
      // Override with mock
      apiClientProvider.overrideWithValue(mockApiClient),

      // Override with test value
      userSessionNotifierProvider.overrideWith(
        () => TestUserSessionNotifier(),
      ),
    ],
  );

  // Test with overridden providers
  final client = container.read(apiClientProvider);
  expect(client, equals(mockApiClient));

  container.dispose();
});
```

---

## Best Practices

### 1. Test Organization

```dart
void main() {
  group('FeatureName', () {
    group('Scenario 1', () {
      test('specific behavior', () { });
    });

    group('Scenario 2', () {
      test('another behavior', () { });
    });
  });
}
```

### 2. Setup and Teardown

```dart
void main() {
  late ProviderContainer container;
  late MockDependency mockDep;

  setUp(() {
    // Run before each test
    container = ProviderContainer();
    mockDep = MockDependency();
  });

  tearDown(() {
    // Run after each test
    container.dispose();
  });

  test('example', () { });
}
```

### 3. Arrange-Act-Assert Pattern

```dart
test('description', () {
  // Arrange - Setup test data
  final notifier = container.read(counterProvider.notifier);
  final initialValue = 5;
  notifier.setValue(initialValue);

  // Act - Perform action
  notifier.increment();

  // Assert - Verify result
  expect(container.read(counterProvider), equals(6));
});
```

### 4. Descriptive Test Names

```dart
// ✅ Good
test('increment increases counter by 1', () { });
test('login with invalid credentials throws ApiException', () { });

// ❌ Bad
test('test increment', () { });
test('login test', () { });
```

### 5. One Assertion Per Test

```dart
// ✅ Good
test('increment increases counter by 1', () {
  notifier.increment();
  expect(container.read(counterProvider), equals(1));
});

test('increment updates state correctly', () {
  notifier.increment();
  expect(container.read(counterProvider), greaterThan(0));
});

// ❌ Avoid
test('increment works', () {
  notifier.increment();
  expect(container.read(counterProvider), equals(1));
  expect(container.read(counterProvider), greaterThan(0));
  expect(container.read(counterProvider), isNot(0));
});
```

### 6. Test Edge Cases

```dart
group('Counter edge cases', () {
  test('decrement at zero stays at zero', () {
    notifier.decrement();
    expect(container.read(counterProvider), equals(0));
  });

  test('handles negative setValue', () {
    notifier.setValue(-5);
    expect(container.read(counterProvider), equals(-5));
  });

  test('handles very large numbers', () {
    notifier.setValue(999999999);
    notifier.increment();
    expect(container.read(counterProvider), equals(1000000000));
  });
});
```

---

## Coverage Goals

### Target Coverage

| Component | Target | Current |
|-----------|--------|---------|
| Providers | 90%+ | 85% |
| Notifiers | 90%+ | 90% |
| Utils | 95%+ | 100% |
| Services | 80%+ | 75% |
| **Overall** | **80%+** | **82%** |

### Generate Coverage

```bash
# Run tests with coverage
flutter test test/unit/ --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# View report
open coverage/html/index.html
```

### Coverage Report

```
Statements   : 82.5% ( 450/545 )
Branches     : 75.3% ( 120/159 )
Functions    : 88.9% ( 80/90 )
Lines        : 84.2% ( 420/499 )
```

---

## Running Tests

### Run All Unit Tests

```bash
flutter test test/unit/
```

### Run Specific Test File

```bash
flutter test test/unit/providers/counter_provider_test.dart
```

### Run with Pattern

```bash
flutter test --name "Counter"
```

### Watch Mode

```bash
flutter test --watch
```

### Verbose Output

```bash
flutter test --verbose
```

---

## Common Patterns

### Testing Loading States

```dart
test('shows loading state during API call', () async {
  final container = ProviderContainer();

  // Start watching
  final subscription = container.listen(
    userListProvider,
    (previous, next) { },
  );

  // Check initial loading
  expect(
    container.read(userListProvider),
    const AsyncLoading<List<User>>(),
  );

  // Wait for completion
  await container.read(userListProvider.future);

  container.dispose();
});
```

### Testing Error States

```dart
test('handles API errors correctly', () async {
  when(mockApi.getUsers()).thenThrow(ApiException('Server error'));

  final container = ProviderContainer(
    overrides: [apiProvider.overrideWithValue(mockApi)],
  );

  final state = await container.read(userListProvider.future)
      .catchError((e) => <User>[]);

  expect(state, isEmpty);
  container.dispose();
});
```

---

## Troubleshooting

### Common Issues

**Issue**: `ProviderNotFoundException`
```dart
// Solution: Add provider override
container = ProviderContainer(
  overrides: [dependencyProvider.overrideWithValue(mockDep)],
);
```

**Issue**: Tests don't update after code change
```bash
# Solution: Rebuild generated files
dart run build_runner build --delete-conflicting-outputs
```

**Issue**: Async tests timeout
```dart
// Solution: Increase timeout
test('slow operation', () async {
  // ...
}, timeout: Timeout(Duration(seconds: 30)));
```

---

## References

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Riverpod Testing Guide](https://riverpod.dev/docs/essentials/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Test Package](https://pub.dev/packages/test)

---

**Next**: [Widget Testing Guide](WIDGET_TESTING_GUIDE.md) | [E2E Testing Guide](E2E_TESTING_GUIDE.md)
