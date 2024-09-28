import 'package:frontend/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('NavBar navigation test', (WidgetTester tester) async {
    // Define a mock navigation observer to verify navigation calls.
    final mockObserver = MockNavigatorObserver();

    // Build the widget tree with MaterialApp to allow navigation.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: NavBar(
            currentIndex: 1,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(tester.element(find.byType(NavBar)), '/camera');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(tester.element(find.byType(NavBar)), '/userplaylist');
                  break;
                case 2:
                  Navigator.pushReplacementNamed(tester.element(find.byType(NavBar)), '/userprofile');
                  break;
                case 3:
                  Navigator.pushReplacementNamed(tester.element(find.byType(NavBar)), '/settings');
                  break;
              }
            },
          ),
        ),
        navigatorObservers: [mockObserver],
        routes: {
          '/camera': (context) => const Scaffold(body: Text('HOME')),
          '/userplaylist': (context) => const Scaffold(body: Text('PLAYLISTS')),
          '/userprofile': (context) => const Scaffold(body: Text('PROFILE')),
          '/settings': (context) => const Scaffold(body: Text('HELP')),
        },
      ),
    );

    // Verify initial state.
    expect(find.text('HOME'), findsOneWidget);

    // Tap on the bottom navigation item at index 0 (Camera).
    // await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.tap(find.byKey(Key('CAMERAICON')));
    await tester.pumpAndSettle(); // Wait for navigation to complete.
    verify(mockObserver.didReplace(
        oldRoute: anyNamed('oldRoute'), newRoute: anyNamed('newRoute')));
    expect(find.text('HOME'), findsOneWidget);

    // Tap on the bottom navigation item at index 2 (User Profile).
    // await tester.tap(find.byIcon(Icons.person));
    // await tester.pumpAndSettle();
    // await tester.tap(find.byKey(Key('PROFILEICON')));
    // expect(find.text('PROFILE'), findsOneWidget);
    //
    // Tap on the bottom navigation item at index 3 (Settings).
    // await tester.tap(find.byIcon(Icons.settings));
    // await tester.tap(find.byKey(Key('HELPICON')));
    // await tester.pumpAndSettle();
    // expect(find.text('HELP'), findsOneWidget);
  });
}