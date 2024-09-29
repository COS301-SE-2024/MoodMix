import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/help_page.dart'; // Update the import path as necessary

void main() {
  // Helper function to build the HelpPage widget
  Widget createHelpPageTestWidget() {
    return MaterialApp(
      home: HelpPage(),
    );
  }

  testWidgets('HelpPage displays app bar with correct title', (WidgetTester tester) async {
    // Act: Build the widget
    await tester.pumpWidget(createHelpPageTestWidget());

    // Assert: Check if the AppBar title is correct
    expect(find.text('Help Page'), findsOneWidget);
  });

  testWidgets('HelpPage displays help sections correctly', (WidgetTester tester) async {
    // Act: Build the widget
    await tester.pumpWidget(createHelpPageTestWidget());

    // Assert: Check if each section title is present
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Playlists'), findsOneWidget);
    expect(find.text('Camera & Voice'), findsOneWidget);
    expect(find.text('FAQ'), findsOneWidget);

    // Assert: Check if each section's items are displayed
    expect(find.text('How to Use Mood Mix'), findsOneWidget);
    expect(find.text('Account Linking'), findsOneWidget);
    expect(find.text('Playlist Generation'), findsOneWidget);
    expect(find.text('How to Add Playlists'), findsOneWidget);
    expect(find.text('Voice Recognition Settings'), findsOneWidget);
    expect(find.text('Camera Setup & Usage'), findsOneWidget);
    expect(find.text('Does it Save My Face?'), findsOneWidget);
    expect(find.text('Is my information secure?'), findsOneWidget);
  });

  testWidgets('HelpPage contains a back button in the AppBar', (WidgetTester tester) async {
    // Act: Build the widget
    await tester.pumpWidget(createHelpPageTestWidget());

    // Assert: Check if the back button (IconButton with arrow_back icon) is present
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('HelpPage displays all sections and their items', (WidgetTester tester) async {
    // Act: Build the widget
    await tester.pumpWidget(createHelpPageTestWidget());

    // Assert: Verify all the help items are displayed under each section
    final helpItems = [
      'How to Use Mood Mix',
      'Account Linking',
      'Playlist Generation',
      'How to Add Playlists',
      'Voice Recognition Settings',
      'Camera Setup & Usage',
      'Does it Save My Face?',
      'Is my information secure?'
    ];

    for (String item in helpItems) {
      expect(find.text(item), findsOneWidget);
    }
  });
}
