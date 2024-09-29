import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_service_test.mocks.dart';



@GenerateMocks([FirebaseAuth, UserCredential, User, GoogleSignIn])
void main() {
  late AuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    // Inject mocks into the AuthService
    authService = AuthService(auth: mockFirebaseAuth, googleSignIn: MockGoogleSignIn());
  });

  group('AuthService Tests', () {
    test('User Registration - Success', () async {
      // Arrange
      final String email = 'test@example.com';
      final String password = 'password123';
      final String username = 'testuser';

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);

      // Act
      final result = await authService.registration(email: email, password: password, username: username);

      // Assert
      expect(result, 'Success');
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).called(1);
      verify(mockUser.updateProfile(displayName: username)).called(1);
    });

    test('User Registration - Weak Password', () async {
      // Arrange
      final String email = 'test@example.com';
      final String password = '123';
      final String username = 'testuser';

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(FirebaseAuthException(code: 'weak-password'));

      // Act
      final result = await authService.registration(email: email, password: password, username: username);

      // Assert
      expect(result, 'The password provided is too weak.');
    });

    test('User Login - Success', () async {
      // Arrange
      final String email = 'test@example.com';
      final String password = 'password123';

      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await authService.login(email: email, password: password);

      // Assert
      expect(result, 'Success');
      verify(mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: password)).called(1);
    });

    test('User Login - User Not Found', () async {
      // Arrange
      final String email = 'test@example.com';
      final String password = 'password123';

      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      // Act
      final result = await authService.login(email: email, password: password);

      // Assert
      expect(result, 'No user found for that email.');
    });

    test('Send Password Reset Email - Success', () async {
      // Arrange
      final String email = 'test@example.com';

      when(mockFirebaseAuth.sendPasswordResetEmail(email: email)).thenAnswer((_) async => {});

      // Act
      final result = await authService.sendPasswordResetEmail(email);

      // Assert
      expect(result, 'Success');
      verify(mockFirebaseAuth.sendPasswordResetEmail(email: email)).called(1);
    });

    test('Send Password Reset Email - User Not Found', () async {
      // Arrange
      final String email = 'test@example.com';

      when(mockFirebaseAuth.sendPasswordResetEmail(email: email)).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      // Act
      final result = await authService.sendPasswordResetEmail(email);

      // Assert
      expect(result, 'No user found for that email.');
    });

    test('Get Current User - Success', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // Act
      final result = await authService.getCurrentUser();

      // Assert
      expect(result, mockUser);
    });
  });
}
