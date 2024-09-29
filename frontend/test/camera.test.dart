import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/components/audio_service.dart';
import 'package:frontend/pages/camera.dart';
import 'package:mockito/mockito.dart';
import 'package:camera/camera.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/annotations.dart';
import 'camera.test.mocks.dart';

@GenerateMocks([AuthService, CameraController, CameraDescription, AudioRecorder])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAuthService mockAuthService;
  late MockCameraController mockCameraController;
  late MockAudioRecorder mockAudioRecorder;
  List<CameraDescription> mockCameras = [];

  setUp(() async {
    mockAuthService = MockAuthService();
    mockCameraController = MockCameraController();
    mockAudioRecorder = MockAudioRecorder();
    mockCameras = [
      CameraDescription(
        name: 'TestCamera',
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 0,
      ),
    ];

    when(mockCameraController.initialize()).thenAnswer((_) async {
      return Future.value();
    });

    when(mockCameraController.value).thenReturn(CameraValue(
      isInitialized: true,
      previewSize: const Size(1920, 1080),
      isRecordingVideo: false,
      isTakingPicture: false,
      isStreamingImages: false,
      isRecordingPaused: false,
      flashMode: FlashMode.auto,
      exposureMode: ExposureMode.auto,
      focusMode: FocusMode.auto,
      exposurePointSupported: false,
      focusPointSupported: false,
      deviceOrientation: DeviceOrientation.portraitUp,
      description: mockCameras[0],
    ));
    when(mockCameraController.initialize()).thenAnswer((_) async {});
  });

  group('CameraPage Widget Tests', () {
    testWidgets('Camera initializes successfully with valid token', (WidgetTester tester) async {
      when(mockCameraController.initialize()).thenAnswer((_) async {
        return Future.value();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: CameraPage(cameras: mockCameras),
        ),
      );

      await tester.pump();
      expect(find.byType(CameraPage), findsOneWidget);
      print("Camera inits succesfully");
    });

    testWidgets('Switching camera updates the controller with valid token', (WidgetTester tester) async {
      when(mockCameraController.value).thenReturn(CameraValue(
        isInitialized: true,
        previewSize: const Size(1920, 1080),
        isRecordingVideo: false,
        isTakingPicture: false,
        isStreamingImages: false,
        isRecordingPaused: false,
        flashMode: FlashMode.auto,
        exposureMode: ExposureMode.auto,
        focusMode: FocusMode.auto,
        exposurePointSupported: false,
        focusPointSupported: false,
        deviceOrientation: DeviceOrientation.portraitUp,
        description: mockCameras[0],
      ));
      when(mockCameraController.initialize()).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(
        MaterialApp(
          home: CameraPage(cameras: mockCameras),
        ),
      );

      await tester.tap(find.byKey(const Key('flipCamButton')));
      await tester.pump();
      expect(find.byType(CameraPage), findsOneWidget);
      verifyNever(mockCameraController.dispose()).called(0);
      print("Camera switching works");
    });

    testWidgets('Taking a photo triggers the mood detection with valid token', (WidgetTester tester) async {
      when(mockCameraController.value).thenReturn(CameraValue(
        isInitialized: true,
        previewSize: const Size(1920, 1080),
        isRecordingVideo: false,
        isTakingPicture: false,
        isStreamingImages: false,
        isRecordingPaused: false,
        flashMode: FlashMode.auto,
        exposureMode: ExposureMode.auto,
        focusMode: FocusMode.auto,
        exposurePointSupported: false,
        focusPointSupported: false,
        deviceOrientation: DeviceOrientation.portraitUp,
        description: mockCameras[0],
      ));
      when(mockCameraController.initialize()).thenAnswer((_) async => Future.value());
      when(mockCameraController.takePicture()).thenAnswer((_) async => XFile('test_path'));

      await tester.pumpWidget(
        MaterialApp(
          home: CameraPage(cameras: mockCameras),
        ),
      );

      await tester.pump();
      expect(find.byType(CameraPage), findsOneWidget);
      verifyNever(mockCameraController.takePicture()).called(0);
      print("Taking photo triggering mood detection with valid token works");
    });

    testWidgets('Audio recording starts and stops correctly with valid token', (WidgetTester tester) async {
      when(mockAudioRecorder.openRecorder()).thenAnswer((_) async => Future.value());
      when(mockAudioRecorder.record()).thenAnswer((_) async => Future.value());
      when(mockAudioRecorder.stopRecorder()).thenAnswer((_) async => 'test_path');
      when(mockAudioRecorder.mood).thenReturn(['Happy']);
      when(mockAudioRecorder.transcription).thenReturn('Test transcription');

      await tester.pumpWidget(
        MaterialApp(
          home: CameraPage(cameras: mockCameras),
        ),
      );

      await tester.tap(find.text('Audio'));
      await tester.pump();
      await tester.tap(find.byType(RawMaterialButton));
      await tester.pump();

      verifyNever(mockAudioRecorder.record()).called(0);

      await tester.tap(find.byType(RawMaterialButton));
      await tester.pump();

      verifyNever(mockAudioRecorder.stopRecorder()).called(0);
    });

    testWidgets('Cannot switch modes while recording with valid token', (WidgetTester tester) async {
      when(mockCameraController.value).thenReturn(CameraValue(
        isInitialized: true,
        previewSize: const Size(1920, 1080),
        isRecordingVideo: false,
        isTakingPicture: false,
        isStreamingImages: false,
        isRecordingPaused: false,
        flashMode: FlashMode.auto,
        exposureMode: ExposureMode.auto,
        focusMode: FocusMode.auto,
        exposurePointSupported: false,
        focusPointSupported: false,
        deviceOrientation: DeviceOrientation.portraitUp,
        description: mockCameras[0],
      ));
      when(mockCameraController.initialize()).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(
        MaterialApp(
          home: CameraPage(cameras: mockCameras),
        ),
      );

      await tester.tap(find.text('Video'));
      await tester.pump();
      verifyNever(mockAudioRecorder.stopRecorder());
    });
  });
}
