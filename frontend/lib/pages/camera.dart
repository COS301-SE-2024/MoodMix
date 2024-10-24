import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import '../auth/auth_service.dart';
import '../components/confirm_pop_up.dart';
import '../components/navbar.dart';
import '../mood_service.dart';
import '../neural_net/neural_net_method_channel.dart';
import '../components/audio_service.dart';

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
 // String? _mood;
  bool isRecording = false;
  Timer? captureTimer;
  List<String> returnedMoods = [];
  List<String> imagePaths = [];
  AudioRecorder audioRecorder = AudioRecorder();
  String audioMoodWeight = '';
  bool audioReady = false;
  bool disabledButton = false;
  GlobalKey _buttonKey = GlobalKey(); // Create a GlobalKey for the button



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
      setState(() async {
        if(!disabledButton) {
          innerCircleSize = innerCircleSize == 50.0 ? 60.0 : 50.0;
          innerCircleColor =
          innerCircleSize == 50.0 ? Colors.red : Colors.white;
          _audioRecord(true);
          _recordRealTime(); // Toggle real-time recording
        }
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
        imagePaths.add(pictureFile!.path); // Add the image path here
        if (pictureFile != null) {
          await _fetchMood(); // Fetch mood after picture is taken
        }
      }

      setState(() {
        innerCircleSize = 60.0;
      });
    } else if (mode == "Audio") {
      _audioRecord(false);
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
        //_mood = mood;
      });
      MoodService().setMood(mood);
      _showConfirmImage(); // Show confirmation after mood fetch
    }
  }

  void _recordRealTime() async {
    if (controller == null || !controller!.value.isInitialized) {
      print("Camera is not initialized.");
      return;
    }

    if (isRecording) {
      // Stop recording
      setState(() async {
        disabledButton = true;
        isRecording = false; // Stop recording
        captureTimer?.cancel(); // Stop the timer
        print("Recording stopped. Moods: $returnedMoods");
        if (audioMoodWeight != '') {
          returnedMoods.add(audioMoodWeight);
        }
        print("Recording stopped. Moods: $returnedMoods");
        audioMoodWeight = '';

        // Check if a picture has been taken
        if (imagePaths.isEmpty) {
          await _takeForcedPicture(); // Take a picture if none exists
        } else {
          int count = 0;
          while (!audioReady && count < 10000) {
            await Future.delayed(Duration(milliseconds: 10)); // Check every 100ms
            count += 1;
          }
          disabledButton = false;
          await _navigateToConfirmationPage(); // Proceed to confirmation if a picture exists
        }
      });
    } else {
      // Start recording
      setState(() {
        isRecording = true; // Start recording
        returnedMoods.clear(); // Clear previous moods
        imagePaths.clear(); // Clear previous image paths
      });

      // Counter for the number of pictures taken
      int pictureCount = 0;

      // Start capturing photos at intervals
      captureTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
        try {
          if (pictureCount >= 4) {
            timer.cancel(); // Stop the timer once 4 pictures are taken
            print("Reached the picture limit of 4.");
            return;
          }

          XFile? pictureFile = await controller?.takePicture();
          if (pictureFile != null) {
            // Send photo to method channel and get the mood
            String? mood = await _neuralNetMethodChannel.get_mood(pictureFile);
            setState(() {
              if (mood != "") {
                returnedMoods.add(mood); // Store the mood
                imagePaths.add(pictureFile.path); // Store the image path
                pictureCount++; // Increment the picture count
              }
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

  void _showConfirmImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationPopUp(
          imagePaths: pictureFile != null ? [pictureFile!.path] : [], // Send a list with a single image
          isFrontCamera: widget.cameras[selectedCameraIndex].lensDirection == CameraLensDirection.front,
          moods: [MoodService().mood],
          isImage: true, // Indicate that it's a single image
          isRealTimeVideo: false,
        );
      },
    ).then((_) {
      setState(() {
        pictureFile = null; // Reset picture file after dialog closes
        disabledButton = false;
      });
    });
  }

  void _showConfirmText(List<String> tMood, String tText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationPopUp(
          moods: tMood,
          isImage: false, // Indicate that it's a single image
          isRealTimeVideo: false,
          transcribedText: tText,
        );
      },
    ).then((_) {
      setState(() {
        pictureFile = null; // Reset picture file after dialog closes
      });
    });
  }

  Future<void> _audioRecord(bool vid) async {
    await audioRecorder.openRecorder();

    if (isAudioActive) {
      // Stop the audio recording
      await audioRecorder.stopRecorder();
      setState(() {
        innerCircleSize = 60.0;
        innerCircleColor = Colors.white;
        isAudioActive = false;
      });
      _timer?.cancel();
      if (!vid) {
        _showConfirmText(audioRecorder.mood, audioRecorder.transcription);
      } else {
        audioMoodWeight = audioRecorder.mood[0];
        audioReady = true;
      }
    } else {
      // Start the audio recording
      await audioRecorder.record();
      audioReady = false;
      setState(() {
        innerCircleSize = 60.0;
        innerCircleColor = Colors.red;
        isAudioActive = true;
      });
      _startPulsing();
    }
  }

  Future<void> _navigateToConfirmationPage() async {
    print("RETURNED MOODS");
    print(returnedMoods.toString());

    if (returnedMoods.length == imagePaths.length) {
      returnedMoods.add(audioMoodWeight);
    }

    // Delay to give visual feedback
    await Future.delayed(Duration(milliseconds: 100));

    // Send all the captured images during real-time video as a list
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationPopUp(
          imagePaths: imagePaths, // Pass the list of all captured images
          transcribedText: audioRecorder.transcription,
          moods: returnedMoods, // Use the calculated moods
          isFrontCamera: widget.cameras[selectedCameraIndex].lensDirection == CameraLensDirection.front,
          isImage: false,
          isRealTimeVideo: true,
        ),
      ),
    );

    if (result == true) {
      // Set disabledButton to true when navigating back
      setState(() {
        disabledButton = false;
      });
    }

    setState(() {
      pictureFile = null;
      returnedMoods.clear();
      imagePaths.clear(); // Clear image paths after confirmation
    });
  }


  Future<void> _takeForcedPicture() async {
    // Capture a picture and fetch mood
    if (controller != null && controller!.value.isInitialized) {
      pictureFile = await controller!.takePicture();
      if (pictureFile != null) {
        imagePaths.add(pictureFile!.path); // Add the image path here
        await _fetchMood(); // Fetch mood after picture is taken
      }
    }
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
                  key: Key('flipCamButton'),
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
                      key: Key('drawerButton'),
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
                      key: _buttonKey,  // Assign the GlobalKey to this button
                      onPressed: disabledButton ? null : _handleButtonPress, // Disable if flag is set
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
                      if (!isRecording && !isAudioActive) {  // Check if not recording before switching mode
                        setState(() => mode = modeItem);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cannot switch modes while recording.')),
                        );
                      }
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50), // Adjust the radius as needed
            bottomRight: Radius.circular(50), // Adjust the radius as needed
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
          activeColor: Theme.of(context).colorScheme.secondary,
          checkColor: Theme.of(context).colorScheme.primary,
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