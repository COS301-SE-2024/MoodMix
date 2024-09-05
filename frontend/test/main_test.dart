import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart' as app;
import 'package:frontend/pages/log_in.dart';
import 'package:frontend/pages/sing_up.dart';
import 'package:frontend/pages/welcome.dart';

void main() {
  testWidgets('Initial Route Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(app.MyApp());

    // Verify that the initial route is the Loading page.
    expect(find.byType(Welcome), findsNothing);
    expect(find.byType(SignUp), findsNothing);
    expect(find.byType(LogIn), findsNothing);
  });

  testWidgets('Navigate To Welcome', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(app.MyApp());

    // Loading navigates to the Welcome page.
    await tester.pumpAndSettle();

    // Verify that the Welcome page is displayed.
    expect(find.byType(Welcome), findsOneWidget);
    expect(find.byType(SignUp), findsNothing);
    expect(find.byType(LogIn), findsNothing);
  });
}
