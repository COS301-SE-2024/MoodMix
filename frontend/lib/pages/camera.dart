import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  int selectedCameraIndex = 0;

  double innerCircleSize = 60.0; // Initial size of the inner circle
  Color innerCircleColor = Colors.white; // Initial color of the inner circle
  String mode = "photo"; // Default mode
  bool isAudioActive = false; // To track if audio mode is active
  Timer? _timer; // Timer for pulsing effect

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isNotEmpty) {
      controller = CameraController(
          widget.cameras[selectedCameraIndex], ResolutionPreset.high);
      try {
        await controller?.initialize();
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        print('Camera initialization error: $e');
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _timer?.cancel(); // Cancel the timer when disposing
    super.dispose();
  }

  void _handleButtonPress() {
    if (mode == "realTimeVideo") {
      setState(() {
        // Toggle size and color in realTimeVideo mode
        innerCircleSize = innerCircleSize == 50.0 ? 60.0 : 50.0;
        innerCircleColor = innerCircleSize == 50.0 ? Colors.red : Colors.white;
      });
    } else if (mode == "photo") {
      // Trigger a one-time size animation in photo mode
      setState(() {
        innerCircleSize = 50.0;
        innerCircleColor = Colors.white;
      });

      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          innerCircleSize = 60.0;
        });
      });
    } else if (mode == "audio") {
      if (isAudioActive) {
        // Stop pulsing and reset size/color
        setState(() {
          innerCircleSize = 60.0;
          innerCircleColor = Colors.white;
          isAudioActive = false;
        });
        _timer?.cancel();
      } else {
        // Start pulsing effect
        setState(() {
          innerCircleSize = 60.0;
          innerCircleColor = Colors.red;
          isAudioActive = true;
        });
        _startPulsing();
      }
    }
  }

  void _startPulsing() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        // Change size and color based on size
        if (innerCircleSize == 53.0) {
          innerCircleSize = 50.0;
          innerCircleColor = Colors.red;
        } else {
          innerCircleSize = 53.0;
          innerCircleColor = Colors.red;
        }
      });
    });
  }

  void _resetAnimation() {
    // Reset animation to the default unpressed state
    setState(() {
      innerCircleSize = 60.0;
      innerCircleColor = Colors.white;
      isAudioActive = false;
    });
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: controller!.value.previewSize!.width,
                height: controller!.value.previewSize!.height,
                child: CameraPreview(controller!),
              ),
            ),
            // Add button with circular outline at the bottom center
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40), // Adjust the distance from bottom
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer circle (static outline)
                    Container(
                      width: 80, // Size of outer circle
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // Outline color
                          width: 4, // Outline width
                        ),
                      ),
                    ),
                    // Inner button (filled circle with size and color animation)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 100), // Animation duration
                      width: innerCircleSize,
                      height: innerCircleSize,
                      decoration: BoxDecoration(
                        color: innerCircleColor,
                        shape: BoxShape.circle,
                      ),
                      child: RawMaterialButton(
                        onPressed: _handleButtonPress,
                        shape: CircleBorder(), // Ensures it's a circle
                        elevation: 2.0,
                        child: null, // No child content for now
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Add buttons to change modes for testing purposes
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Reset animation when switching modes
          _resetAnimation();

          setState(() {
            mode = mode == "photo"
                ? "realTimeVideo"
                : mode == "realTimeVideo"
                ? "audio"
                : "photo";
          });
        },
        child: Icon(Icons.switch_camera),
      ),
    );
  }
}
