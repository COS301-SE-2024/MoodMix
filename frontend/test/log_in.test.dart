import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/pages/log_in.dart';
import 'package:mockito/mockito.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/annotations.dart';
import 'log_in.test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  group('LogIn Widget Tests', () {
    testWidgets('Successful login shows success message', (WidgetTester tester) async {
      // Arrange
      when(mockAuthService.login(email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => 'Success');

      await tester.pumpWidget(
        MaterialApp(
          home: LogIn(authService: mockAuthService),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(); // Allow time for the Snackbar to appear

      // Assert
      verify(mockAuthService.login(email: 'test@example.com', password: 'password123')).called(1);
    });

    testWidgets('Login fails with wrong password', (WidgetTester tester) async {
      // Arrange
      when(mockAuthService.login(email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => 'Wrong password provided for that user.');

      await tester.pumpWidget(
        MaterialApp(
          home: LogIn(authService: mockAuthService),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'wrongpassword');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget); // Check if the Snackbar is shown
      expect(find.text('Wrong password provided for that user.'), findsOneWidget);
      verify(mockAuthService.login(email: 'test@example.com', password: 'wrongpassword')).called(1);
    });

    testWidgets('Password reset sends email', (WidgetTester tester) async {
      // Arrange
      when(mockAuthService.sendPasswordResetEmail(any))
          .thenAnswer((_) async => 'Success');

      await tester.pumpWidget(
        MaterialApp(
          home: LogIn(authService: mockAuthService),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Password reset email sent'), findsOneWidget);
      verify(mockAuthService.sendPasswordResetEmail('test@example.com')).called(1);
    });

    testWidgets('Forgot password without email shows error', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: LogIn(authService: mockAuthService),
        ),
      );

      // Act
      await tester.tap(find.byType(TextButton).first); // Trigger forgot password
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please enter your email'), findsOneWidget);

    });
  });
}
