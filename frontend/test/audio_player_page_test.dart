import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:audioplayers/audioplayers.dart';
// Adjust import path

// Mock class for AudioPlayer
class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  group('AudioPlayerPage', () {
    late MockAudioPlayer mockAudioPlayer;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
    });

    testWidgets('Play/Pause Button Test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp());

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);

      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();

      expect(find.byIcon(Icons.pause), findsOneWidget);

      await tester.tap(find.byIcon(Icons.pause));
      await tester.pump();

      verify(mockAudioPlayer.pause()).called(1);

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);


    });
    testWidgets('Navigate Back Test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
      ));
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      verify(mockAudioPlayer.pause()).called(1);

      expect(find.text('Welcome to Homepage'), findsOneWidget);
    });
  });
}
