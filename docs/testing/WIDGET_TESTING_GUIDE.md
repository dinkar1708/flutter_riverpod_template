# Widget Testing Guide


## Overview

Widget testing verifies UI components render correctly and respond to user interactions. This guide covers testing Flutter widgets with Riverpod providers.

## Basic Widget Test

### Simple Widget

```dart
void main() {
  testWidgets('displays welcome message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WelcomePage(),
      ),
    );

    expect(find.text('Welcome'), findsOneWidget);
  });
}
```

### Widget with Riverpod

```dart
void main() {
  testWidgets('counter displays initial value', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: CounterPage(),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('increment button increases counter', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: CounterPage(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
```

## Testing with Provider Overrides

### Mock Provider Data

```dart
testWidgets('displays user session', (tester) async {
  final mockSession = UserSession(
    username: 'testuser',
    email: 'test@example.com',
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userSessionNotifierProvider.overrideWith(
          (ref) => mockSession,
        ),
      ],
      child: MaterialApp(
        home: ProfilePage(),
      ),
    ),
  );

  expect(find.text('testuser'), findsOneWidget);
  expect(find.text('test@example.com'), findsOneWidget);
});
```

## Testing Async Widgets

### Loading State

```dart
testWidgets('shows loading indicator', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: UserListPage(),
      ),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### Data State

```dart
testWidgets('displays list of users', (tester) async {
  final mockUsers = [
    User(id: 1, name: 'Alice'),
    User(id: 2, name: 'Bob'),
  ];

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userListProvider.overrideWith((ref) => mockUsers),
      ],
      child: MaterialApp(
        home: UserListPage(),
      ),
    ),
  );

  await tester.pumpAndSettle();

  expect(find.text('Alice'), findsOneWidget);
  expect(find.text('Bob'), findsOneWidget);
});
```

## Testing User Interactions

### Button Taps

```dart
testWidgets('login button triggers login', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: LoginPage(),
      ),
    ),
  );

  await tester.enterText(find.byType(TextField).first, 'username');
  await tester.enterText(find.byType(TextField).last, 'password');

  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();

  expect(find.text('Welcome'), findsOneWidget);
});
```

### Form Validation

```dart
testWidgets('shows validation error for empty email', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: LoginPage(),
      ),
    ),
  );

  await tester.tap(find.text('Login'));
  await tester.pump();

  expect(find.text('Email is required'), findsOneWidget);
});
```

## Testing Navigation

```dart
testWidgets('navigates to home after login', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: LoginPage(),
      ),
    ),
  );

  await tester.enterText(find.byType(TextField).first, 'user');
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();

  expect(find.byType(HomePage), findsOneWidget);
});
```

## Common Patterns

### Find Widgets

```dart
// By text
find.text('Hello')

// By type
find.byType(ElevatedButton)

// By icon
find.byIcon(Icons.search)

// By key
find.byKey(Key('submit-button'))

// By widget
find.byWidget(MyCustomWidget())
```

### Pump Methods

```dart
// Trigger frame
await tester.pump();

// Wait for animations
await tester.pumpAndSettle();

// Pump with duration
await tester.pump(Duration(seconds: 1));
```

## Running Widget Tests

```bash
flutter test test/widget/
```

## References

See Unit Testing Guide for more patterns.
