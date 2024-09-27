import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/mood_service.dart';
import 'playlist_details.dart';

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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isRealTimeVideo && widget.imagePaths != null && widget.imagePaths!.isNotEmpty) {
      _pageController = PageController();
    }
  }

  @override
  void dispose() {
    if (widget.isRealTimeVideo) {
      _pageController.dispose();
    }
    super.dispose();
  }

  String get currentMood {
    if (widget.moods.isEmpty) {
      return 'No mood detected'; // Fallback if moods list is empty
    }

    if (widget.isRealTimeVideo) {
      // Ensure index is within bounds of the moods list
      return widget.moods.length > _currentIndex
          ? widget.moods[_currentIndex][0].toUpperCase() + widget.moods[_currentIndex].substring(1)
          : 'No mood detected';
    } else {
      // Check if there is only one unique mood
      return widget.moods.toSet().length == 1
          ? widget.moods.first[0].toUpperCase() + widget.moods.first.substring(1)
          : 'Mixed Mood';
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
              ? Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.imagePaths!.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final imagePath = widget.imagePaths![index];
                    final file = File(imagePath);
                    if (!file.existsSync()) {
                      return Center(
                        child: Icon(Icons.error, color: Colors.red, size: 100),
                      );
                    }
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi * 2), // Flip the image horizontally
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0), // No rounding for full-screen image
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.file(
                            file,
                            fit: BoxFit.cover, // Ensure the image fills the screen
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(Icons.error, color: Colors.red, size: 100),
                              ); // Fallback image if there's an error loading the image
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Page Indicator
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Image ${_currentIndex + 1} of ${widget.imagePaths!.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          )
              : widget.transcribedText != null
              ? PageView.builder(
            itemCount: 1, // Only one item (for text display)
            itemBuilder: (context, index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    widget.transcribedText != null && widget.transcribedText!.isNotEmpty
                        ? widget.transcribedText!
                        : 'No transcription available',
                    style: TextStyle(
                      fontSize: 24, // Adjust text size
                      color: Theme.of(context).colorScheme.secondary, // Use secondary theme color
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center, // Center the text
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
                return Center(
                  child: Icon(Icons.error, color: Colors.red, size: 100),
                ); // Show error icon if file does not exist
              }
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi * 2), // Flip the image horizontally
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0), // No rounding for full-screen image
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.file(
                      file,
                      fit: BoxFit.cover, // Ensure the image fills the screen
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.error, color: Colors.red, size: 100),
                        ); // Fallback image if there's an error loading the image
                      },
                    ),
                  ),
                ),
              );
            },
          )
              : Center(
              child: Icon(Icons.error, color: Colors.white, size: 100)), // Fallback if neither condition is met
        ),
        // Mood display text at the top of the screen
        Positioned(
          top: screenHeight * 0.05,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          child: Text(
            currentMood,
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: widget.transcribedText != null && widget.isRealTimeVideo == false
                  ? Theme.of(context).colorScheme.secondary // Use secondary color if transcribed text is not null
                  : Colors.white, // Use white if transcribed text is null
              decoration: TextDecoration.none, // Remove underline
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Controls for retake and continue buttons
        if (widget.isImage || widget.transcribedText != null || widget.isRealTimeVideo)
          Positioned(
            bottom: screenHeight * 0.1,
            left: screenWidth * 0.2,
            right: screenWidth * 0.2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Background container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Make the background container transparent
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Retake button
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle with gradient opacity
                          FloatingActionButton(
                            heroTag: 'retake', // Unique tag for retake button
                            backgroundColor: Theme.of(context).colorScheme.primary, // Keep the FAB's background transparent
                            onPressed: () {
                              Navigator.of(context).pop(); // Closes the pop-up
                            },
                            child: Icon(
                              Icons.refresh,
                              size: 50,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      // Continue button
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle with gradient opacity
                          FloatingActionButton(
                            heroTag: 'continue',
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            onPressed: () async {
                              // Continue button logic
                            },
                            child: Icon(
                              Icons.check,
                              size: 50,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
