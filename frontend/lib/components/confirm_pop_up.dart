import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/mood_service.dart';
import 'playlist_details.dart';
import '../mood_service.dart';

class ConfirmationPopUp extends StatefulWidget {
  final String? imagePath;
  final String? transcribedText;
  final bool isFrontCamera;
  final List<String> moods; // List of moods
  final bool isImage;
  final bool isRealTimeVideo; // New parameter for real-time video
  final List<String>? imagePaths; // List of image paths for real-time video

  const ConfirmationPopUp({
    Key? key,
    this.imagePath,
    this.transcribedText,
    required this.moods,
    this.isFrontCamera = false,
    this.isImage = true,
    this.isRealTimeVideo = false, // Defaults to false
    this.imagePaths, // Optional parameter for image paths
  }) : super(key: key);

  @override
  _ConfirmationPopUpState createState() => _ConfirmationPopUpState();
}

class _ConfirmationPopUpState extends State<ConfirmationPopUp> {
  late PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isRealTimeVideo && widget.imagePaths != null && widget.imagePaths!.isNotEmpty) {
      _pageController = PageController();
      _startAutoPageChange();
    }
  }

  void _startAutoPageChange() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_pageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % widget.imagePaths!.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {}); // Refresh to update the mood display
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (widget.isRealTimeVideo) {
      _pageController.dispose();
    }
    super.dispose();
  }

  String get currentMood {
    if (widget.isRealTimeVideo && widget.moods.isNotEmpty) {
      // Get the mood associated with the current index for carousel images
      if (widget.moods.length > _currentIndex) {
        return widget.moods[_currentIndex][0].toUpperCase() + widget.moods[_currentIndex].substring(1); // Capitalize first letter
      } else {
        return 'No mood detected';
      }
    } else {
      if (widget.moods.isEmpty) {
        return 'No mood detected';
      } else if (widget.moods.toSet().length == 1) {
        return widget.moods.first[0].toUpperCase() + widget.moods.first.substring(1); // Capitalize first letter
      } else {
        return 'Mixed Mood';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background blur effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        // Image display logic
        Positioned.fill(
          child: widget.isRealTimeVideo && widget.imagePaths != null && widget.imagePaths!.isNotEmpty
              ? PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePaths!.length,
            itemBuilder: (context, index) {
              final imagePath = widget.imagePaths![index];
              print('Displaying image at index $index: $imagePath'); // Debugging: Print current image path
              final file = File(imagePath);
              if (!file.existsSync()) {
                print('File does not exist: $imagePath'); // Debugging: File existence
                return Center(child: Icon(Icons.error, color: Colors.red, size: 100)); // Show error icon if file does not exist
              }
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi), // Flip the image horizontally
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0), // No rounding for full-screen image
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.file(
                      file,
                      fit: BoxFit.cover, // Ensure the image fills the screen
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error'); // Debugging: Error loading image
                        return Center(child: Icon(Icons.error, color: Colors.red, size: 100)); // Fallback image if there's an error loading the image
                      },
                    ),
                  ),
                ),
              );
            },
          )
              : widget.isImage
              ? PageView.builder(
            itemCount: 1, // Only one image
            itemBuilder: (context, index) {
              final file = File(widget.imagePaths![0]);
              if (!file.existsSync()) {
                print('File does not exist: ${widget.imagePath}'); // Debugging: File existence
                return Center(child: Icon(Icons.error, color: Colors.red, size: 100)); // Show error icon if file does not exist
              }
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi), // Flip the image horizontally
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0), // No rounding for full-screen image
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.file(
                      file,
                      fit: BoxFit.cover, // Ensure the image fills the screen
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error'); // Debugging: Error loading image
                        return Center(child: Icon(Icons.error, color: Colors.red, size: 100)); // Fallback image if there's an error loading the image
                      },
                    ),
                  ),
                ),
              );
            },
          )
              : Center(child: Icon(Icons.error, color: Colors.white, size: 100)), // Fallback if neither condition is met
        ),
        // Mood display text at the top of the screen
        Positioned(
          top: screenHeight * 0.05,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          child: Text(
            currentMood,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Mood text is white
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Positioned Container for other UI elements
        Positioned(
          top: screenHeight * 0.035,
          left: screenWidth * 0.1,
          right: screenWidth * 0.1,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                // Your other content (like moods, transcribed text) goes here
              ],
            ),
          ),
        ),
        // Controls for retake and continue buttons
        if (widget.isImage || widget.transcribedText != null || widget.isRealTimeVideo)
          Positioned(
            bottom: screenHeight * 0.15,
            left: screenWidth * 0.2,
            right: screenWidth * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Retake button
                FloatingActionButton(
                  heroTag: 'retake', // Unique tag for retake button
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  onPressed: () {
                    Navigator.of(context).pop(); // Closes the pop-up
                  },
                  child: Icon(
                    Icons.refresh,
                    size: 50,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                // Continue button
                FloatingActionButton(
                  heroTag: 'continue', // Unique tag for continue button
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  onPressed: () {
                    Navigator.of(context).pop(); // Closes the pop-up

                    if (widget.isRealTimeVideo) {
                      SpotifyAuth.realTimeCreateAndPopulatePlaylistWithRecommendations(
                          "MoodMix",
                          widget.moods
                      );
                    } else {
                      SpotifyAuth.createAndPopulatePlaylistWithRecommendations(
                          "MoodMix",
                          widget.moods.first
                      );
                    }

                    Navigator.pushReplacementNamed(context, '/userplaylist');
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    size: 50,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
