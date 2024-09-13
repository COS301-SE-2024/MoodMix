import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'dart:io';

import 'package:frontend/components/navbar.dart';
import 'package:frontend/neural_net/neural_net_method_channel.dart';
import 'package:frontend/components/confirm_pop_up.dart'; // Import ConfirmationPopUp
import '../components/audio_recorder.dart'; // Import AudioRecorder
import '../auth/auth_service.dart';
import '../components/custom_scrollbar.dart';
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
  bool isRecording = false;
  Timer? captureTimer;
  List<String> returnedMoods = [];

  static String playlistMood = "";
  final NeuralNetMethodChannel _neuralNetMethodChannel = NeuralNetMethodChannel();

  List<String>? genres = [];
  List<String> selectedGenres = [];
  List<bool> checkBoxSelected = [];
  List<bool> isChecked = [false, false, false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeMethodChannel();
    SpotifyAuth.fetchUserDetails();
    // _fetchGenres();
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
        _handleError('Camera initialization error: $e');
      }
    }
  }

  Future<void> _switchCamera() async {
    if (widget.cameras.length > 1) {
      setState(() {
        selectedCameraIndex = (selectedCameraIndex + 1) % widget.cameras.length;
      });
      await _initializeCamera(); // Reinitialize with the new camera
    }
  }

  Future<void> _initializeMethodChannel() async {
    const MethodChannel _channel = MethodChannel('neural_net_method_channel');
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'recieveMood':
          _handleSuccess(call.arguments);
          break;
        case 'onError':
          _handleError(call.arguments);
          break;
        default:
          throw MissingPluginException('Not implemented: ${call.method}');
      }
    });
  }

  void _handleSuccess(String mood) {
    print("Received mood from AI: $mood");
    setState(() {
      _mood = mood;
    });
    MoodService().setMood(mood); // Update mood service
  }

  void _handleError(String error) {
    print('Error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')));
  }

  Future<void> _fetchMood() async {
    if (pictureFile != null) {
      String? mood = await _neuralNetMethodChannel.get_mood(pictureFile);
      if (mood != null) {
        setState(() {
          _mood = mood;
        });
        _showConfirmImage(); // Show confirmation after mood fetch
      }
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  //Might have to use a Different Genre fetching method because this pulls similar genres
  // void _fetchGenres() async{
  //   final genresFetched = await SpotifyAuth.fetchUserTopArtistsAndTracks();
  //   if(genresFetched != null){
  //     setState(() {
  //       genres = genresFetched['genres'];
  //     });
  //   }
  // }

  void _setGenres() {
    SpotifyAuth().setSelectedGenres(selectedGenres);
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
      });

      // Start capturing photos at intervals
      captureTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
        try {
          pictureFile = await controller?.takePicture();
          if (pictureFile != null) {
            // Send photo to method channel and get the mood
            String? mood = await _neuralNetMethodChannel.get_mood(pictureFile);
            if (mood != null) {
              setState(() {
                returnedMoods.add(mood); // Store the mood
              });
              print("Captured mood: $mood");
            }
          }
        } catch (e) {
          print("Error during intermittent capture: $e");
          timer.cancel(); // Stop the timer in case of an error
        }
      });
    }
  }

  void _navigateToConfirmationPage() {
    // String transcribedText = returnedMoods.join(", ");
    print("RETURNED MOODS");
    print(returnedMoods.toString());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationPopUp(
          imagePath: pictureFile?.path,
          transcribedText: returnedMoods.toString(),
          moods: returnedMoods ?? [],
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
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: FlashingScrollbarWidget(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Text(
                        "Playlist Generation",
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: screenWidth * 0.9,
                      height: screenWidth * 0.9 * controller!.value.aspectRatio,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            AspectRatio(
                              aspectRatio: controller!.value.aspectRatio,
                              child: CameraPreview(controller!),
                            ),
                            Builder(
                              builder: (BuildContext context) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: IconButton(
                                      icon: Icon(Icons.menu, color: Color.fromARGB(255, 200, 200, 200)),
                                      onPressed: () {
                                        Scaffold.of(context).openDrawer();
                                      },
                                    ),
                                  ),
                                );
                              },
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
                                          if (pictureFile != null) {
                                            await _fetchMood(); // Fetch mood after picture is taken
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
                                    Positioned(
                                      bottom: 0.0,
                                      left: 16.0,
                                      child: IconButton(
                                        onPressed: _recordRealTime,
                                        icon: Icon(
                                          isRecording ? Icons.stop : Icons.videocam,
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
                  SizedBox(height: 40), // Adjust this height as needed
                  Divider(indent: screenWidth * 0.07, endIndent: screenWidth * 0.07,),
                  SizedBox(height: 15), // Adjust this height as needed
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(screenWidth * 0.08, 0, screenWidth * 0.08, 0),
                      child: Text(
                        "Hold down the Microphone button to record audio.",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40), // Adjust this height as needed
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    alignment: Alignment.center,
                    child: AudioRecorder(
                      onPressed: () {
                        print('Audio recording toggled');
                        // Handle the recording state change here
                      },
                    ),
                  ),
                  SizedBox(height: 40), // Adjust this height as needed
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigator.pushReplacementNamed(context, '/camera');
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
        child:ListView(

          // padding: EdgeInsets.zero,
          children:<Widget>[
            DrawerHeader(
              child: Text(
                'Select your Music Preferences',
                style: TextStyle(
                  // color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  fontSize:24,
                ),
              ),
            ),
            CheckboxListTile(
              title: Text('Alternative'),
              value: isChecked[4],
              activeColor: Colors.black,
              checkColor: Colors.green,
              onChanged: (bool? newValue){
                setState(() {
                  if(newValue == true){
                    for(int i = 0; i < 9; i++){
                      isChecked[i] = false;
                    }
                    selectedGenres.clear();
                    selectedGenres.add('Alternative');
                    isChecked[4] = newValue ?? false;
                    _setGenres();
                  }
                  else{
                    selectedGenres.remove('Latin');
                    isChecked[4] = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('Classical'),
              value: isChecked[0],
              activeColor: Colors.black,
              checkColor: Colors.green,
              onChanged: (bool? newValue){
                setState(() {
                  if(newValue == true){
                    for(int i = 0; i < 9; i++){
                      isChecked[i] = false;
                    }
                    selectedGenres.clear();
                    selectedGenres.add('Classical');
                    isChecked[0] = newValue ?? false;
                    _setGenres();
                  }
                  else{
                    selectedGenres.remove('Classical');
                    isChecked[0] = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('Country'),
              value: isChecked[1],
              activeColor: Colors.black,
              checkColor: Colors.green,
              onChanged: (bool? newValue){
                setState(() {
                  if(newValue == true){
                    for(int i = 0; i < 9; i++){
                      isChecked[i] = false;
                    }
                    selectedGenres.clear();
                    selectedGenres.add('Country');
                    isChecked[1] = newValue ?? false;
                    _setGenres();
                  }
                  else{
                    selectedGenres.remove('Country');
                    isChecked[1] = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('Hip Hop'),
              value: isChecked[2],
              activeColor: Colors.black,
              checkColor: Colors.green,
              onChanged: (bool? newValue){
                setState(() {
                  if(newValue == true){
                    for(int i = 0; i < 9; i++){
                      isChecked[i] = false;
                    }
                    selectedGenres.clear();
                    selectedGenres.add('Hip Hop');
                    isChecked[2] = newValue ?? false;
                    _setGenres();
                  }
                  else{
                    selectedGenres.remove('Hip Hop');
                    isChecked[2] = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('Jazz'),
              value: isChecked[3],
              activeColor: Colors.black,
              checkColor: Colors.green,
              onChanged: (bool? newValue){
                setState(() {
                  if(newValue == true){
                    for(int i = 0; i < 9; i++){
                      isChecked[i] = false;
                    }
                    selectedGenres.clear();
                    selectedGenres.add('Jazz');
                    isChecked[3] = newValue ?? false;
                    _setGenres();
                  }
                  else{
                    selectedGenres.remove('Jazz');
                    isChecked[3] = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('Pop'),
              value: isChecked[5],
              activeColor: Colors.black,
              checkColor: Colors.green,
              onChanged: (bool? newValue){
                setState(() {
                  if(newValue == true){
                    for(int i = 0; i < 9; i++){
                      isChecked[i] = false;
                    }
                    selectedGenres.clear();
                    selectedGenres.add('Pop');
                    isChecked[5] = newValue ?? false;
                    _setGenres();
                  }
                  else{
                    selectedGenres.remove('Pop');
                    isChecked[5] = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('R&B'),
              value: isChecked[6],
              activeColor: Colors.black,
              checkColor: Colors.green,
              onChanged: (bool? newValue){
                setState(() {
                  if(newValue == true){
                    for(int i = 0; i < 9; i++){
                      isChecked[i] = false;
                    }
                    selectedGenres.clear();
                    selectedGenres.add('R&B');
                    isChecked[6] = newValue ?? false;
                    _setGenres();
                  }
                  else{
                    selectedGenres.remove('R&B');
                    isChecked[6] = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('Reggae'),
              value: isChecked[7],
              activeColor: Colors.black,
              checkColor: Colors.green,
              onChanged: (bool? newValue){
                setState(() {
                  if(newValue == true){
                    for(int i = 0; i < 9; i++){
                      isChecked[i] = false;
                    }
                    selectedGenres.clear();
                    selectedGenres.add('Reggae');
                    isChecked[7] = newValue ?? false;
                    _setGenres();
                  }
                  else{
                    selectedGenres.remove('Reggae');
                    isChecked[7] = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text('Rock'),
              value: isChecked[8],
              activeColor: Colors.black,
              checkColor: Colors.green,
              onChanged: (bool? newValue){
                setState(() {
                  if(newValue == true){
                    for(int i = 0; i < 9; i++){
                      isChecked[i] = false;
                    }
                    selectedGenres.clear();
                    selectedGenres.add('Rock');
                    isChecked[8] = newValue ?? false;
                    _setGenres();
                  }
                  else{
                    selectedGenres.remove('Rock');
                    isChecked[8] = false;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}