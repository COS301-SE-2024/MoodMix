import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/components/navbar.dart';

void main() {
  testWidgets('NavBar shows correct icons', (WidgetTester tester) async {
    // Arrange
    const currentIndex = 0;
    final mockOnTap = (int index) {};

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: NavBar(
            currentIndex: currentIndex,
            onTap: mockOnTap,
          ),
        ),
      ),
    );

    // Assert
    expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
    expect(find.byIcon(Icons.my_library_music_outlined), findsOneWidget);
    expect(find.byIcon(Icons.history_outlined), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });

  testWidgets('NavBar triggers onTap callback on tap', (WidgetTester tester) async {
    // Arrange
    const currentIndex = 0;
    int tappedIndex = -1;
    final mockOnTap = (int index) {
      tappedIndex = index;
    };

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: NavBar(
            currentIndex: currentIndex,
            onTap: mockOnTap,
          ),
        ),
      ),
    );

    // Tap on the second item (index 1)
    await tester.tap(find.byIcon(Icons.my_library_music_outlined));
    await tester.pump();

    // Assert
    expect(tappedIndex, 1);
  });
}
