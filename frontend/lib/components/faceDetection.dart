import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionHelper {
  final FaceDetector _faceDetector;

  FaceDetectionHelper()
      : _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableLandmarks: true,
      enableContours: true,
    ),
  );

  Future<bool> isFacePresent(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);

      final List<Face> faces = await _faceDetector.processImage(inputImage);

      return faces.isNotEmpty;
    } catch (e) {
      print("Error during face detection: $e");
      return false;
    }
  }

  void dispose() {
    _faceDetector.close();
  }
}
