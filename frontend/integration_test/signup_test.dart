//Firebase and Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/pages/signup.dart';

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
class MockFirestoreInstance extends Mock implements FirebaseFirestore{}

void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Signup Test", () {
    late MockFirebaseAuth mockAuth;
    late MockFirestoreInstance mockFirestoreInstance;

    setUp((){
      mockAuth = MockFirebaseAuth();
      mockFirestoreInstance = MockFirestoreInstance();
    });

    testWidgets("New User Signup", (WidgetTester tester) async {
      when(mockAuth.createUserWithEmailAndPassword(
        email: 'testUser@test.com',
        password: 'testpassword123',
      ));

      await tester.pumpWidget(
        MaterialApp(
          home:SignUp(
          ),
        ),
      );

      await tester.enterText(find.byKey(Key('Email')), 'testUser@test.com');
      await tester.enterText(find.byKey(Key('Username')), 'UserTest');
      await tester.enterText(find.byKey(Key('Password')), 'testpassword123');
      await tester.enterText(find.byKey(Key('Confirm Password')), 'testpassword123');

      await tester.tap(find.byKey(Key('Create')));
      await tester.pump();

      final userSnapshot = await mockFirestoreInstance.collection('Users').get();
      final users = userSnapshot.docs;

      expect(users.length, 1);
      expect(users.first['email'], 'testUser@test.com');
      expect(users.first['Username'], 'UserTest');
    });

    // testWidgets("Email already in use", (WidgetTester tester) async{
    //   when(mockAuth.)
    // });

  });

}