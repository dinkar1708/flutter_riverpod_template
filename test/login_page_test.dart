import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod_template/feature/login/views/login_page.dart';

void main() {
  group('LoginPage Tests', () {
    testWidgets('LoginPage renders all essential widgets', (WidgetTester tester) async {
      // Build the LoginPage widget wrapped in necessary providers
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginPage(title: 'Login Test'),
          ),
        ),
      );

      // Verify that the login page renders
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);

      // Verify username and password fields exist
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Verify buttons exist
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('Username and password fields accept input', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginPage(title: 'Login Test'),
          ),
        ),
      );

      // Find the text fields
      final usernameFinder = find.widgetWithText(TextField, 'Enter username');
      final passwordFinder = find.widgetWithText(TextField, 'Enter password');

      // Enter text into username field
      await tester.enterText(usernameFinder, 'testuser');
      expect(find.text('testuser'), findsOneWidget);

      // Enter text into password field
      await tester.enterText(passwordFinder, 'testpassword');
      expect(find.text('testpassword'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginPage(title: 'Login Test'),
          ),
        ),
      );

      // Find the password field
      final passwordField = find.widgetWithText(TextField, 'Enter password');
      expect(passwordField, findsOneWidget);

      // Verify password is initially obscured
      TextField passwordTextField = tester.widget(passwordField);
      expect(passwordTextField.obscureText, true);

      // Tap the visibility toggle button
      final visibilityToggle = find.byIcon(Icons.visibility_off);
      expect(visibilityToggle, findsOneWidget);
      await tester.tap(visibilityToggle);
      await tester.pump();

      // Verify password is now visible
      passwordTextField = tester.widget(passwordField);
      expect(passwordTextField.obscureText, false);

      // Verify the icon changed
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Login button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginPage(title: 'Login Test'),
          ),
        ),
      );

      // Find the login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Sign In');
      expect(loginButton, findsOneWidget);

      // Verify button is enabled
      final ElevatedButton button = tester.widget(loginButton);
      expect(button.enabled, true);
    });

    testWidgets('Demo mode info banner is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginPage(title: 'Login Test'),
          ),
        ),
      );

      // Verify demo mode banner exists
      expect(find.text('Demo Mode: Default username is "dinkar1708"'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });
}
