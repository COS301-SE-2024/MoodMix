//Firebase and Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

//Imports for the Test
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

//Pages to Import
import 'package:frontend/main.dart' as app;
import 'package:frontend/pages/log_in.dart';
import 'package:frontend/firebase_options.dart';


class FirebaseInstance extends Mock implements Firebase {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirestoreInstance extends Mock implements FirebaseFirestore {}

void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockFirebaseAuth mockAuth;

  setUpAll(() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    mockAuth = MockFirebaseAuth();
  });

  group('Login Integration Tests:', () {

    // setUp(() async {
    //   await Firebase.initializeApp();
    //   mockAuth = MockFirebaseAuth();
    // });

    testWidgets('Test Login with Email and Password:', (WidgetTester tester) async{

      await tester.pumpWidget(
          MaterialApp(
            home: LogIn(),
          )
      );


      final emailField = find.byKey(Key('Username or Email'));
      final passwordField = find.byKey(Key('Password'));
      final loginButton = find.byKey(Key('Login Button'));

      await tester.enterText(emailField, "tester@example.com");
      await tester.enterText(passwordField, "myPassword");

      await tester.tap(loginButton);

      await tester.pump();

      verify(mockAuth.signInWithEmailAndPassword(
          email: "tester@example.com",
          password: "myPassword"
      )).called(1);

      expect(find.text("Login Successful"), findsOneWidget);

    });

    testWidgets('Test Wrong Details:', (WidgetTester tester) async{
      when(mockAuth.signInWithEmailAndPassword(
        email: 'anyEmail@gmail.com',
        password: 'anyPassword',
      ))
          .thenThrow(FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user was found for the specified email'
      ));

      await tester.pumpWidget(
          MaterialApp(
            home: LogIn(),
          )
      );

      final emailField = find.byKey(Key('Username or Email'));
      final passwordField = find.byKey(Key('Password'));
      final loginButton = find.byKey(Key('Login Button'));

      await tester.enterText(emailField, "non-existenttester@example.com");
      await tester.enterText(passwordField, "nonexistent-myPassword");

      await tester.tap(loginButton);

      await tester.pump();

      expect(find.text('Login failed'), findsOneWidget);
    });
  });

  // throw Exception('Unsupported action code info');
}