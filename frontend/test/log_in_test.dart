import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/log_in.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  group('LogIn Page Tests', () {
    testWidgets('LogIn page UI test', (WidgetTester tester) async {
      // Build the LogIn widget
      await tester.pumpWidget(MaterialApp(home: LogIn()));

      // Expect to find the 'Log In' text twice
      expect(find.text('Log In'), findsNWidgets(2));

      // Expect to find the 'Username or Email' TextField
      expect(
          find.byWidgetPredicate((widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Username or Email'),
          findsOneWidget);

      // Expect to find the 'Password' TextField
      expect(
          find.byWidgetPredicate((widget) =>
              widget is TextField && widget.decoration?.hintText == 'Password'),
          findsOneWidget);

      // Expect to find the 'Log In' button
      expect(find.widgetWithText(OutlinedButton, 'Log In'), findsOneWidget);

      // Expect to find the 'Create Account' text span
      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              widget.text.toPlainText() ==
                  'Don\'t have an account?\nCreate Account\n\nTerms and Conditions'),
          findsOneWidget);
    });

    // testWidgets('LogIn with mock Firebase Auth', (WidgetTester tester) async {
    //   final mockUser = MockUser(
    //     isAnonymous: false,
    //     uid: 'someuid',
    //     email: 'test@example.com',
    //   );
    //   final auth = MockFirebaseAuth(mockUser: mockUser);

    //   // Inject the mock Firebase Auth into the LogIn widget
    //   await tester.pumpWidget(MaterialApp(
    //     home: LogIn(),
    //   ));

    //   // Find and enter text into the email and password fields
    //   await tester.enterText(find.byHintText('Username or Email'), 'test@example.com');
    //   await tester.enterText(find.byHintText('Password'), 'password');

    //   // Tap the 'Log In' button
    //   await tester.tap(find.widgetWithText(OutlinedButton, 'Log In'));
    //   await tester.pumpAndSettle();

    //   // Verify that the login method was called
    //   verify(auth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password')).called(1);
    // });
  });
}
