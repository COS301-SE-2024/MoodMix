import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

final File imageFile = getImageFile();//temp fuction, need to figure out hwo we get the image here
final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(imageFile);

final FaceDetector faceDetector = GoogleVision.instance.faceDetector();

final List<Face> faces = await faceDetector.processImage(visionImage);

for (Face face in faces) {
  final Rectangle<int> boundingBox = face.boundingBox;

  final double rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
  final double rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees
  //below is just example code, can be used later for whatever, all we really need to do is check if the faces array is empty
  final FaceLandmark leftEar = face.getLandmark(FaceLandmarkType.leftEar);
  if (leftEar != null) {
    final Point<double> leftEarPos = leftEar.position;
  }

  if (face.smilingProbability != null) {
    final double smileProb = face.smilingProbability;
  }

  if (face.trackingId != null) {
    final int id = face.trackingId;
  }
}

faceDetector.close();