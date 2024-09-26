import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:camera/camera.dart';

import 'package:frontend/pages/camera.dart';

import 'camera_test.mocks.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();

  late CameraController mockCameraController;
  late CameraDescription mockCameraDescription;

  setUpAll(() async{
    mockCameraDescription = CameraDescription(
      name: 'Mock Camera',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 90,
    );

    mockCameraController = CameraController(mockCameraDescription, ResolutionPreset.high);
  });

  testWidgets("Testing Camera Page Loads and Takes Picture", (WidgetTester tester) async{
    // when(mockCameraController.value).thenReturn(CameraValue(
    //     isInitialized: true,
    //     previewSize: const Size(1920,1080),
    //     isRecordingVideo: false,
    //     isTakingPicture: false,
    //     isStreamingImages: false,
    //     isRecordingPaused: false,
    //     flashMode: FlashMode.off,
    //     exposureMode: ExposureMode.auto,
    //     focusMode: FocusMode.auto,
    //     exposurePointSupported: false,
    //     focusPointSupported: false,
    //     deviceOrientation: DeviceOrientation.portraitUp,
    //     description: mockCameraDescription,
    // ));

    List<CameraDescription> cameraControllers = [mockCameraDescription];

    await tester.pumpWidget(
      MaterialApp(
        home: CameraPage(cameras: cameraControllers),
      ),
    );

    expect(find.byType(CameraPage), findsOneWidget);

    final iconFinder = find.byIcon(Icons.camera_alt);

    final takePictureButton = find.widgetWithIcon(IconButton, Icons.camera_alt);
    expect(takePictureButton, findsOneWidget);
    await tester.tap(takePictureButton);

    verify(mockCameraController.takePicture()).called(1);

  });

}