import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/sing_up.dart'; // Import your SignUp widget

void main() {
  testWidgets('SignUp page UI test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    
    // Build the SignUp widget
    await tester.pumpWidget(MaterialApp(home: SignUp()));

    // Expect to find the 'Create Your Account' text
    expect(find.text('Create Your\nAccount'), findsOneWidget);

    // Expect to find the 'Username' TextField
    expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);

    // Expect to find the 'Email' TextField
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);

    // Expect to find the 'Password' TextField
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

    // Expect to find the 'Confirm Password' TextField
    expect(find.widgetWithText(TextField, 'Confirm Password'), findsOneWidget);

    // Expect to find the 'Create' button
    expect(find.widgetWithText(OutlinedButton, 'Create'), findsOneWidget);

    expect(find.byWidgetPredicate(
      (widget) =>
          widget is RichText &&
          widget.text.toPlainText() == 'Already have an account?\nLog In\n\nTerms and Conditions',
    ), findsOneWidget);
  });
}