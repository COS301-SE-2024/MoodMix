import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/log_in.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core

void main() {
  // Initialize Firebase before running the tests
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('LogIn page UI test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LogIn()));

    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Username or Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Don\'t have an account?'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Terms and Conditions'), findsOneWidget);
  });
}
