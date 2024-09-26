import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/camera.dart';

void main() {
  final List<CameraDescription> cameras;

  testWidgets('Navbar test: Verify BottomNavigationBar functionality', (WidgetTester tester) async {
    // Build the MyHomePage widget.
    await tester.pumpWidget(
      MaterialApp(
        home: CameraPage(cameras: []),
      ),
    );

    // Verify that the BottomNavigationBar exists.
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify that all the tabs (items) are present in the BottomNavigationBar.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('userlaylists'), findsOneWidget);
    expect(find.text('userprofile'), findsOneWidget);
    expect(find.text('settings'), findsOneWidget);

    // Verify that the default screen is the "Home" screen.
    expect(find.text('Home Screen'), findsOneWidget);
    expect(find.text('Settings Screen'), findsNothing);
    expect(find.text('userlaylists'), findsNothing);
    expect(find.text('userprofile'), findsNothing);
    expect(find.text('settings'), findsNothing);

    // Tap on the "Settings" tab and verify it switches to the "Settings" screen.
    await tester.tap(find.text('Settings'));
    await tester.pump(); // Rebuild the widget after the state has changed.

    // Verify the "Settings Screen" is now shown.
    expect(find.text('Settings Screen'), findsOneWidget);
    expect(find.text('Home Screen'), findsNothing);
    expect(find.text('userlaylists'), findsNothing);
    expect(find.text('userprofile'), findsNothing);
    expect(find.text('settings'), findsNothing);


    // Tap back to the "Home" tab and verify it switches to the "Home" screen.
    await tester.tap(find.text('Home'));
    await tester.pump(); // Rebuild the widget after the state has changed.

    // Verify the "Home Screen" is now shown.
    expect(find.text('Home Screen'), findsOneWidget);
    expect(find.text('Settings Screen'), findsNothing);
    expect(find.text('userlaylists'), findsNothing);
    expect(find.text('userprofile'), findsNothing);
    expect(find.text('settings'), findsNothing);

  });
}