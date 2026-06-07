// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/my_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test - launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(
          launchTitle: "Test",
        ),
      ),
    );

    // Wait for app to build completely
    await tester.pumpAndSettle();

    // Verify the app launches without errors
    expect(find.byType(MyApp), findsOneWidget);
  });
}
