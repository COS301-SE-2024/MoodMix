import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/welcome.dart'; // Import your Welcome widget

void main() {
  testWidgets('Welcome page UI test', (WidgetTester tester) async {
    // Build the Welcome widget
    await tester.pumpWidget(MaterialApp(home: Welcome()));

    // Expect to find the 'Sign Up' button
    expect(find.byKey(Key('signupButton')), findsOneWidget);

    // Expect to find the 'Log In' button
    expect(find.byKey(Key('loginButton')), findsOneWidget);

    // Expect to find the 'Terms and Conditions' text
    expect(find.text('Terms and Conditions'), findsOneWidget);
  });
}
