import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/pages/sing_up.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'sign_up_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  // Function to create the widget under test
  Widget createWidgetUnderTest() {
    return MaterialApp(
      routes: {
        '/': (context) => SignUp(authService: mockAuthService),
        '/linkspotify': (context) => Placeholder(), // Mock target screen
      },
    );
  }


  group('SignUp Widget Tests', () {
    testWidgets('renders input fields and buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextField), findsNWidgets(4)); // 4 text fields
      expect(find.byKey(Key('createAccountButton')), findsOneWidget); // Create button
      expect(find.text('Create your account'), findsOneWidget); // Title text
    });

    testWidgets('shows snackbar if passwords do not match', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField).at(0), 'username'); // Username
      await tester.enterText(find.byType(TextField).at(1), 'email@example.com'); // Email
      await tester.enterText(find.byType(TextField).at(2), 'password123'); // Password
      await tester.enterText(find.byType(TextField).at(3), 'password'); // Confirm Password (not matching)

      // Scroll down by dragging
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle(); // Let the scroll animation settle

      await tester.tap(find.byKey(Key('createAccountButton')));
      await tester.pump(); // Rebuild the widget after the state has changed

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('navigates to /linkspotify on successful registration', (WidgetTester tester) async {
      when(mockAuthService.registration(
        email: anyNamed('email'),
        password: anyNamed('password'),
        username: anyNamed('username'),
      )).thenAnswer((_) async => 'Success'); // Mocking the registration response

      await tester.pumpWidget(createWidgetUnderTest());

      // Fill in the text fields
      await tester.enterText(find.byType(TextField).at(0), 'username');
      await tester.enterText(find.byType(TextField).at(1), 'email@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.enterText(find.byType(TextField).at(3), 'password123'); // Matching password

      // Scroll down by dragging (if necessary)
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle(); // Let the scroll animation settle

      // Tap the create account button
      await tester.tap(find.byKey(Key('createAccountButton')));
      await tester.pumpAndSettle(); // Wait for animations

      // Check that we navigate to the new screen
      expect(find.byType(Placeholder), findsOneWidget); // Verify the target screen
    });

    testWidgets('shows snackbar if registration fails', (WidgetTester tester) async {
      when(mockAuthService.registration(
        email: anyNamed('email'),
        password: anyNamed('password'),
        username: anyNamed('username'),
      )).thenAnswer((_) async => 'Registration failed'); // Mocking the registration response

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField).at(0), 'username');
      await tester.enterText(find.byType(TextField).at(1), 'email@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.enterText(find.byType(TextField).at(3), 'password123'); // Matching password

      // Scroll down by dragging
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle(); // Let the scroll animation settle

      await tester.tap(find.byKey(Key('createAccountButton')));
      await tester.pump(); // Rebuild the widget after the state has changed

      expect(find.text('Registration failed'), findsOneWidget);
    });
  });
}