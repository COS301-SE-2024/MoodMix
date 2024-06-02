import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/welcome.dart';

void main() {
  testWidgets('Welcome page UI test', (WidgetTester tester) async {
    // Set the window size
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(MaterialApp(home: Welcome()));

    // Your test expectations
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Terms and Conditions'), findsOneWidget);
  });
}
