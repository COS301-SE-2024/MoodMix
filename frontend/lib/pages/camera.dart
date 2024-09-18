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

  double innerCircleSize = 60.0;
  Color innerCircleColor = Colors.white;
  String mode = "Photo";
  bool isAudioActive = false;
  Timer? _timer;

  final List<String> modes = ["Photo", "Real-Time Video", "Audio"];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _initializeCamera();

    _pageController.addListener(() {
      final int page = _pageController.page?.round() ?? 0;
      if (page < modes.length) {
        setState(() {
          mode = modes[page];
        });
      }
    });
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isNotEmpty) {
      if (controller != null) {
        await controller!.dispose();
        controller = null;
      }
      controller = CameraController(
        widget.cameras[selectedCameraIndex],
        ResolutionPreset.high,
      );
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
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _handleButtonPress() {
    if (mode == "Real-Time Video") {
      setState(() {
        innerCircleSize = innerCircleSize == 50.0 ? 60.0 : 50.0;
        innerCircleColor = innerCircleSize == 50.0 ? Colors.red : Colors.white;
      });
    } else if (mode == "Photo") {
      setState(() {
        innerCircleSize = 50.0;
        innerCircleColor = Colors.white;
      });

      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          innerCircleSize = 60.0;
        });
      });
    } else if (mode == "Audio") {
      if (isAudioActive) {
        setState(() {
          innerCircleSize = 60.0;
          innerCircleColor = Colors.white;
          isAudioActive = false;
        });
        _timer?.cancel();
      } else {
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
    setState(() {
      innerCircleSize = 60.0;
      innerCircleColor = Colors.white;
      isAudioActive = false;
    });
    _timer?.cancel();
  }

  Future<void> _switchCamera() async {
    // Placeholder for camera switch logic
  }

  void _handlePageChange(int index) async {
    setState(() {
      mode = modes[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ClipRect(
                child: OverflowBox(
                  maxWidth: screenSize.width + 1000,
                  maxHeight: screenSize.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: screenSize.height,
                      height: screenSize.height * (controller!.value.previewSize!.width / controller!.value.previewSize!.height),
                      child: CameraPreview(controller!),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.switch_camera_outlined),
                color: Colors.white,
                onPressed: _switchCamera,
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.info_outline),
                color: Colors.white,
                onPressed: () {
                  print('Info icon pressed');
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 150),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      width: innerCircleSize,
                      height: innerCircleSize,
                      decoration: BoxDecoration(
                        color: innerCircleColor,
                        shape: BoxShape.circle,
                      ),
                      child: RawMaterialButton(
                        onPressed: _handleButtonPress,
                        shape: CircleBorder(),
                        elevation: 2.0,
                        child: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: modes.length,
                        onPageChanged: (index) {
                          if (index < modes.length) {
                            _handlePageChange(index);
                          }
                        },
                        itemBuilder: (context, index) {
                          final currentMode = modes[index];
                          return Center(
                            child: Text(
                              currentMode,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 10,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          modes.length,
                              (index) {
                            final bool isActive = (_pageController.page?.round() ?? 0) == index;
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: isActive ? 24 : 8,
                              height: 8,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: isActive ? Colors.green : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
