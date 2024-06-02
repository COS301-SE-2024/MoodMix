// test/sing_up_test.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/sign_up.dart';

void main() {

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  
  testWidgets('SignUp page UI test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUp()));

    expect(find.text('Create Your\nAccount'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Terms and Conditions'), findsOneWidget);
  });
}
