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
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isRealTimeVideo &&
        widget.imagePaths != null &&
        widget.imagePaths!.isNotEmpty) {
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
        return widget.moods[_currentIndex][0].toUpperCase() +
            widget.moods[_currentIndex].substring(1); // Capitalize first letter
      } else {
        return 'No mood detected';
      }
    } else {
      if (widget.moods.isEmpty) {
        return 'No mood detected';
      } else if (widget.moods.toSet().length == 1) {
        return widget.moods.first[0].toUpperCase() +
            widget.moods.first.substring(1); // Capitalize first letter
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
          child: widget.isRealTimeVideo &&
                  widget.imagePaths != null &&
                  widget.imagePaths!.isNotEmpty
              ? NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent) {
                      // If reached the last image, reset index
                      _currentIndex = 0; // Reset index to the first image
                      _pageController.jumpToPage(
                          _currentIndex); // Jump back to the first image
                    }
                    return true;
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.imagePaths!.length,
                    itemBuilder: (context, index) {
                      final imagePath = widget.imagePaths![index];
                      final file = File(imagePath);
                      if (!file.existsSync()) {
                        return Center(
                            child: Icon(Icons.error,
                                color: Colors.red, size: 100));
                      }
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(
                            math.pi * 2), // Flip the image horizontally
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              0.0), // No rounding for full-screen image
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.file(
                              file,
                              fit: BoxFit
                                  .cover, // Ensure the image fills the screen
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                    child: Icon(Icons.error,
                                        color: Colors.red,
                                        size:
                                            100)); // Fallback image if there's an error loading the image
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
                              child: Icon(Icons.error,
                                  color: Colors.red,
                                  size:
                                      100)); // Show error icon if file does not exist
                        }
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(
                              math.pi * 2), // Flip the image horizontally
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                0.0), // No rounding for full-screen image
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Image.file(
                                file,
                                fit: BoxFit
                                    .cover, // Ensure the image fills the screen
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                      child: Icon(Icons.error,
                                          color: Colors.red,
                                          size:
                                              100)); // Fallback image if there's an error loading the image
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(Icons.error,
                          color: Colors.white,
                          size: 100)), // Fallback if neither condition is met
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
        if (widget.isImage ||
            widget.transcribedText != null ||
            widget.isRealTimeVideo)
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
                    color: Colors
                        .transparent, // Make the background container transparent
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Retake button
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle with gradient opacity
                          Container(
                            width: 80, // Adjust size based on FAB size
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(
                                          0.1), // Least opaque at the center
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(
                                          0.3), // More opaque towards the edges
                                ],
                                stops: [
                                  0.5,
                                  1.0
                                ], // Control the spread of the gradient
                                center: Alignment.center,
                                radius: 1.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          FloatingActionButton(
                            heroTag: 'retake', // Unique tag for retake button
                            backgroundColor: Colors
                                .transparent, // Keep the FAB's background transparent
                            onPressed: () {
                              Navigator.of(context).pop(); // Closes the pop-up
                            },
                            child: Icon(
                              Icons.refresh,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Continue button
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle with gradient opacity
                          Container(
                            width: 80, // Adjust size based on FAB size
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(
                                          0.1), // Least opaque at the center
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(
                                          0.3), // More opaque towards the edges
                                ],
                                stops: [
                                  1.0,
                                  0.01
                                ], // Control the spread of the gradient
                                center: Alignment.center,
                                radius: 1.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          FloatingActionButton(
                            heroTag: 'continue',
                            backgroundColor: Colors
                                .transparent, // Keep the FAB's background transparent
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, // Full screen background
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary, // Keep indicator color
                                      ),
                                    ),
                                  ),
                                ),
                              );

                              try {
                                if (widget.isRealTimeVideo) {
                                  await SpotifyAuth
                                      .realTimeCreateAndPopulatePlaylistWithRecommendations(
                                    "MoodMix",
                                    widget.moods,
                                  );
                                } else {
                                  await SpotifyAuth
                                      .createAndPopulatePlaylistWithRecommendations(
                                    "MoodMix",
                                    widget.moods.first,
                                  );
                                }

                                // Close the loading indicator
                                Navigator.of(context).pop();

                                // Navigate to the user playlist page after completion
                                Navigator.pushReplacementNamed(context, '/userplaylist');
                              } catch (error) {
                                // Close the loading indicator if there's an error
                                Navigator.of(context).pop();
                                // Show error dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Failed to create playlist. Please try again.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Icon(
                              Icons.check,
                              size: 50,
                              color: Colors.white,
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
