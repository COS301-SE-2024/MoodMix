// test/mocks/mock_firebase_auth.dart
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  MockUser({required this.isAnonymous, required this.uid, required this.email});
  @override
  final bool isAnonymous;
  @override
  final String uid;
  @override
  final String? email;
}


class MockUserCredential extends Mock implements UserCredential {}

class MockAdditionalUserInfo extends Mock implements AdditionalUserInfo {}