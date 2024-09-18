import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import '../auth/auth_service.dart';
import '../components/confirm_pop_up.dart';
import '../components/navbar.dart';
import '../mood_service.dart';
import '../neural_net/neural_net_method_channel.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  int selectedCameraIndex = 0;
  bool isCameraReady = false;
  double innerCircleSize = 60.0;
  Color innerCircleColor = Colors.white;
  String mode = "Photo";
  bool isAudioActive = false;
  Timer? _timer;
  XFile? pictureFile;
  String? _mood;
  bool isRecording = false;
  Timer? captureTimer;
  List<String> returnedMoods = [];

  final List<String> modes = ["Photo", "Video", "Audio"];
  final List<String> selectedGenres = [];
  final List<bool> isChecked = List<bool>.generate(9, (_) => false); // To manage checkboxes for genres

  final NeuralNetMethodChannel _neuralNetMethodChannel = NeuralNetMethodChannel();

  @override
  void initState() {
    super.initState();
    isRecording = false; // Initialize recording state
    _initializeCamera();
    SpotifyAuth.fetchUserDetails();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isNotEmpty) {
      setState(() => isCameraReady = false);

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
          setState(() => isCameraReady = true);
        }
      } catch (e) {
        print('Camera initialization error: $e');
      }
    }
  }

  Future<void> _switchCamera() async {
    setState(() {
      selectedCameraIndex = (selectedCameraIndex + 1) % widget.cameras.length;
    });
    await _initializeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    _timer?.cancel();
    captureTimer?.cancel(); // Cancel capture timer if exists
    super.dispose();
  }

  void _handleButtonPress() async {
    if (mode == "Video") {
      setState(() {
        innerCircleSize = innerCircleSize == 50.0 ? 60.0 : 50.0;
        innerCircleColor = innerCircleSize == 50.0 ? Colors.red : Colors.white;
        _recordRealTime(); // Toggle real-time recording
      });
    } else if (mode == "Photo") {
      setState(() {
        innerCircleSize = 50.0;
        innerCircleColor = Colors.white;
      });

      // Delay to give a visual feedback
      await Future.delayed(Duration(milliseconds: 200));

      // Capture picture and fetch mood
      if (controller != null && controller!.value.isInitialized) {
        pictureFile = await controller!.takePicture();
        if (pictureFile != null) {
          await _fetchMood(); // Fetch mood after picture is taken
        }
      }

      setState(() {
        innerCircleSize = 60.0;
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
        innerCircleSize = innerCircleSize == 53.0 ? 50.0 : 53.0;
        innerCircleColor = Colors.red;
      });
    });
  }

  void _setGenres() {
    print('Selected genres: $selectedGenres');
  }

  Future<void> _fetchMood() async {
    if (pictureFile != null) {
      String? mood = await _neuralNetMethodChannel.get_mood(pictureFile);
      setState(() {
        _mood = mood;
      });
      MoodService().setMood(mood);
      _showConfirmImage(); // Show confirmation after mood fetch
    }
  }

  void _showConfirmImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationPopUp(
          imagePath: pictureFile!.path,
          isFrontCamera: widget.cameras[selectedCameraIndex].lensDirection ==
              CameraLensDirection.front,
          moods: [MoodService().mood],
        );
      },
    ).then((_) {
      setState(() {
        pictureFile = null; // Reset picture file after dialog closes
      });
    });
  }

  void _recordRealTime() {
    if (controller == null || !controller!.value.isInitialized) {
      print("Camera is not initialized.");
      return;
    }

    if (isRecording) {
      // Stop recording
      setState(() {
        isRecording = false; // Stop recording
        captureTimer?.cancel(); // Stop the timer
        print("Recording stopped. Moods: $returnedMoods");
        _navigateToConfirmationPage();
      });
    } else {
      // Start recording
      setState(() {
        isRecording = true; // Start recording
        returnedMoods.clear(); // Clear previous moods
      });

      // Start capturing photos at intervals
      captureTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
        try {
          pictureFile = await controller?.takePicture();
          if (pictureFile != null) {
            // Send photo to method channel and get the mood
            String? mood = await _neuralNetMethodChannel.get_mood(pictureFile);
            setState(() {
              returnedMoods.add(mood ?? 'Unknown'); // Store the mood
            });
            print("Captured mood: $mood");
          }
        } catch (e) {
          print("Error during intermittent capture: $e");
          timer.cancel(); // Stop the timer in case of an error
        }
      });
    }
  }

  Future<void> _navigateToConfirmationPage() async {
    print("RETURNED MOODS");
    print(returnedMoods.toString());

    // Delay to give a visual feedback
    await Future.delayed(Duration(milliseconds: 200));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationPopUp(
          imagePath: pictureFile?.path,
          transcribedText: returnedMoods.toString(),
          moods: returnedMoods,
          isFrontCamera: widget.cameras[selectedCameraIndex].lensDirection ==
              CameraLensDirection.front,
          isImage: false,
          isRealTimeVideo: true,
        ),
      ),
    ).then((_) {
      setState(() {
        pictureFile = null;
        returnedMoods.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: isCameraReady && controller != null && controller!.value.isInitialized
                ? ClipRect(
              child: OverflowBox(
                maxWidth: screenSize.width + 1000,
                maxHeight: screenSize.height,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: screenSize.height,
                    height: screenSize.height *
                        (controller!.value.previewSize!.width / controller!.value.previewSize!.height),
                    child: CameraPreview(controller!),
                  ),
                ),
              ),
            )
                : Center(child: CircularProgressIndicator()),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: Stack(
              children: [
                // Shadow behind the icon
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.switch_camera_outlined),
                  color: Colors.white,
                  onPressed: _switchCamera,
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Builder(
              builder: (BuildContext context) {
                return Stack(
                  children: [
                    // Shadow behind the icon
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4), // Shadow position
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.tune_rounded),
                      color: Colors.white,
                      onPressed: () => Scaffold.of(context).openDrawer(), // Open the drawer
                    ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
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
            bottom: 18,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: modes.map((String modeItem) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => mode = modeItem);
                    },
                    child: Text(
                      modeItem,
                      style: TextStyle(
                        color: mode == modeItem ? Colors.green : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Select your genre of preference',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ..._buildGenreCheckboxes(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGenreCheckboxes() {
    final genres = [
      'Classical',
      'Country',
      'Hip Hop',
      'Jazz',
      'Alternative',
      'Pop',
      'R&B',
      'Reggae',
      'Rock'
    ];

    return List<Widget>.generate(
      genres.length,
          (index) {
        return CheckboxListTile(
          title: Text(genres[index]),
          value: isChecked[index],
          activeColor: Colors.black,
          checkColor: Colors.green,
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue == true) {
                isChecked.fillRange(0, isChecked.length, false);
                selectedGenres.clear();
                selectedGenres.add(genres[index]);
                isChecked[index] = true;
                _setGenres();
              } else {
                selectedGenres.remove(genres[index]);
                isChecked[index] = false;
              }
            });
          },
        );
      },
    );
  }
}