import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'dart:io';

import 'package:frontend/components/navbar.dart';
import 'package:frontend/components/playlist_ribon.dart';
import 'package:frontend/neural_net/neural_net_method_channel.dart';
import 'package:frontend/components/confirm_pop_up.dart'; // Import ConfirmationPopUp
import '../components/audio_recorder.dart'; // Import AudioRecorder
import '../auth/auth_service.dart';
import '../mood_service.dart';


class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({Key? key, required this.cameras}) : super(key: key);


  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  XFile? pictureFile;
  int selectedCameraIndex = 0;
  String? _mood;

  static String playlistMood = "";
  final NeuralNetMethodChannel _neuralNetMethodChannel = NeuralNetMethodChannel();

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      controller = CameraController(widget.cameras[selectedCameraIndex], ResolutionPreset.high);
      controller?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      }).catchError((error) {
        print('Camera initialization error: $error');
      });
    }
    _initializeMethodChannel();
    SpotifyAuth.fetchUserDetails();
  }




  void _initializeMethodChannel() {
    const MethodChannel _channel = MethodChannel('neural_net_method_channel');
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'recieveMood':
        String mood = call.arguments;
        _handleSuccess(mood);
        break;
      case 'onError':
        String error = call.arguments;
        _handleError(error);
        break;
      default:
        throw MissingPluginException('Not implemented: ${call.method}');
    }
  }

  static void _handleSuccess(String mood) {
    print("Received mood from AI: $mood");
    MoodService().setMood(mood);
    // Update UI or do other things with mood if needed
  }

  static void _handleError(String error) {
    print('Error: $error');
  }

  String sendMood() {
    return playlistMood;
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _switchCamera() {
    if (widget.cameras.length > 1) {
      selectedCameraIndex = (selectedCameraIndex + 1) % widget.cameras.length;
      controller = CameraController(widget.cameras[selectedCameraIndex], ResolutionPreset.high);
      controller?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      }).catchError((error) {
        print('Camera initialization error: $error');
      });
    }
  }

  void _showConfirmImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationPopUp(
          imagePath: pictureFile!.path,
          isFrontCamera: widget.cameras[selectedCameraIndex].lensDirection == CameraLensDirection.front, mood: 'Happy', // Check if the front camera was used
        );
      },
    ).then((_) {
      // Reset pictureFile after dialog is closed
      setState(() {
        pictureFile = null;
      });
    });
  }

  void _fetchMood() async {
    String? mood = await _neuralNetMethodChannel.get_mood(pictureFile);
    if (mood != null) {
      setState(() {
        _mood = mood;
      });
      _showConfirmImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: screenWidth * 0.8,
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                AspectRatio(
                                  aspectRatio: controller!.value.aspectRatio,
                                  child: CameraPreview(controller!),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(
                                          bottom: 0.0,
                                          child: IconButton(
                                            onPressed: () async {
                                              pictureFile = await controller?.takePicture();
                                              await _neuralNetMethodChannel.get_mood(pictureFile);
                                              setState(() {});
                                              if (pictureFile != null) {
                                                _showConfirmImage(); // Show ConfirmImage after taking the picture
                                              }
                                            },
                                            icon: Icon(
                                              Icons.camera_alt,
                                              color: Color.fromARGB(255, 200, 200, 200),
                                              size: 40.0,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0.0,
                                          right: 16.0,
                                          child: IconButton(
                                            onPressed: _switchCamera,
                                            icon: Icon(
                                              Icons.swap_horiz,
                                              color: Color.fromARGB(255, 200, 200, 200),
                                              size: 30.0,
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
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                          alignment: Alignment.center,
                          child: AudioRecorder(
                            onPressed: () {
                              // Handle the recording state change here
                              print('Audio recording toggled');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/camera');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/userplaylist');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/userprofile');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }
}
