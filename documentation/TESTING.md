# Testing Guide

This document provides detailed information about testing in the Flutter Riverpod Template project.

## Table of Contents
1. [Running Tests](#running-tests)
2. [Test Cases](#test-cases)
3. [Test Coverage](#test-coverage)
4. [Writing New Tests](#writing-new-tests)

## Running Tests

### Run All Tests
Execute all test cases in the project:
```bash
flutter test
```

### Run Specific Test File
Execute tests from a specific file:
```bash
flutter test test/login_page_test.dart
```

### Run Tests with Coverage
Generate test coverage report:
```bash
flutter test --coverage
```

### Run Tests in Watch Mode
Automatically re-run tests when files change:
```bash
flutter test --watch
```

## Test Cases

### Login Page Tests
**Location:** `test/login_page_test.dart`

The login page test suite validates the core functionality of the login screen. Below are the test cases included:

#### 1. LoginPage renders all essential widgets
**Purpose:** Verifies that the login page displays all necessary UI components

**Validations:**
- "Welcome Back!" title is displayed
- "Sign in to continue" subtitle is shown
- Username field exists with correct label
- Password field exists with correct label
- Sign In button is rendered
- Continue with Google button is present
- Continue with Apple button is present
- Continue as Guest button is available
- Forgot Password? button exists

**Test Code Example:**
```dart
testWidgets('LoginPage renders all essential widgets', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: LoginPage(title: 'Login Test'),
      ),
    ),
  );

  expect(find.text('Welcome Back!'), findsOneWidget);
  expect(find.text('Sign in to continue'), findsOneWidget);
  // ... additional assertions
});
```

#### 2. Username and password fields accept input
**Purpose:** Tests text input functionality for login fields

**Validations:**
- Username field accepts text input
- Password field accepts text input
- Entered text is properly displayed
- Text fields are editable

**Test Code Example:**
```dart
testWidgets('Username and password fields accept input', (WidgetTester tester) async {
  // ... setup code

  final usernameFinder = find.widgetWithText(TextField, 'Enter username');
  await tester.enterText(usernameFinder, 'testuser');
  expect(find.text('testuser'), findsOneWidget);

  // ... password field test
});
```

#### 3. Password visibility toggle works
**Purpose:** Validates password field security and visibility toggle functionality

**Validations:**
- Password field is initially obscured (obscureText = true)
- Visibility toggle icon is displayed (visibility_off)
- Tapping toggle reveals password (obscureText = false)
- Icon changes to visibility when password is shown
- Toggle state persists correctly

**Test Code Example:**
```dart
testWidgets('Password visibility toggle works', (WidgetTester tester) async {
  // ... setup code

  // Verify password is initially obscured
  TextField passwordTextField = tester.widget(passwordField);
  expect(passwordTextField.obscureText, true);

  // Tap visibility toggle
  final visibilityToggle = find.byIcon(Icons.visibility_off);
  await tester.tap(visibilityToggle);
  await tester.pump();

  // Verify password is now visible
  passwordTextField = tester.widget(passwordField);
  expect(passwordTextField.obscureText, false);
});
```

#### 4. Login button is tappable
**Purpose:** Ensures the login button is interactive and functional

**Validations:**
- Login button is rendered correctly
- Button is enabled (not disabled)
- Button can be found by text "Sign In"
- Button is an ElevatedButton type

**Test Code Example:**
```dart
testWidgets('Login button is tappable', (WidgetTester tester) async {
  // ... setup code

  final loginButton = find.widgetWithText(ElevatedButton, 'Sign In');
  expect(loginButton, findsOneWidget);

  final ElevatedButton button = tester.widget(loginButton);
  expect(button.enabled, true);
});
```

#### 5. Demo mode info banner is displayed
**Purpose:** Validates that users are informed about demo mode functionality

**Validations:**
- Demo mode banner is visible
- Correct message is displayed: "Demo Mode: Default username is 'dinkar1708'"
- Info icon (Icons.info_outline) is shown
- Banner uses proper styling with primary color scheme

**Test Code Example:**
```dart
testWidgets('Demo mode info banner is displayed', (WidgetTester tester) async {
  // ... setup code

  expect(find.text('Demo Mode: Default username is "dinkar1708"'), findsOneWidget);
  expect(find.byIcon(Icons.info_outline), findsOneWidget);
});
```

## Test Coverage

### Current Coverage
The current test suite focuses on:

**Widget Rendering:**
- Verification that all UI components render correctly
- Layout and structure validation
- Text and icon presence checks

**User Interactions:**
- Text input functionality
- Button tap interactions
- Toggle button state changes

**State Management:**
- Password visibility toggle state
- Form field state management
- Widget local state handling

**User Experience:**
- Demo mode information display
- Accessibility features
- Error prevention (password obscuring)

### Coverage Metrics
To view detailed coverage metrics:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Writing New Tests

### Test Structure
Follow this structure when writing new tests:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feature Name Tests', () {
    testWidgets('Test description', (WidgetTester tester) async {
      // 1. Setup: Build widget with necessary providers
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: YourWidget(),
          ),
        ),
      );

      // 2. Act: Perform actions (tap, enter text, etc.)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // 3. Assert: Verify expected outcomes
      expect(find.text('Expected Text'), findsOneWidget);
    });
  });
}
```

### Best Practices

1. **Use Descriptive Test Names**
   - Good: `testWidgets('Login button shows loading state when API is called')`
   - Bad: `testWidgets('test1')`

2. **Test One Thing at a Time**
   - Each test should verify a single behavior or feature
   - Keep tests focused and atomic

3. **Use ProviderScope for Riverpod Tests**
   - Always wrap your widget in `ProviderScope`
   - Mock providers when testing API interactions

4. **Clean Up Resources**
   - Dispose controllers and resources in tearDown
   - Reset provider state between tests

5. **Test User Journeys**
   - Test complete user flows, not just isolated widgets
   - Verify navigation and state transitions

### Common Testing Patterns

#### Testing Text Input
```dart
final textField = find.byType(TextField);
await tester.enterText(textField, 'test input');
expect(find.text('test input'), findsOneWidget);
```

#### Testing Button Taps
```dart
final button = find.widgetWithText(ElevatedButton, 'Submit');
await tester.tap(button);
await tester.pump(); // Rebuild widget after state change
```

#### Testing Async Operations
```dart
await tester.tap(find.text('Load Data'));
await tester.pump(); // Start async operation
await tester.pump(Duration(seconds: 1)); // Wait for completion
expect(find.text('Data Loaded'), findsOneWidget);
```

#### Testing Navigation
```dart
await tester.tap(find.text('Next'));
await tester.pumpAndSettle(); // Wait for navigation animation
expect(find.text('Next Page'), findsOneWidget);
```

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Riverpod Testing Guide](https://riverpod.dev/docs/essentials/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
