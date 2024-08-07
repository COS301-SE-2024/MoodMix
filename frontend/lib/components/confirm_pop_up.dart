import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'playlist_details.dart'; // Import the playlist_details.dart file

class ConfirmationPopUp extends StatefulWidget {
  final String imagePath;
  final bool isFrontCamera;
  final String mood;

  const ConfirmationPopUp({
    Key? key,
    required this.imagePath,
    required this.mood,
    this.isFrontCamera = false,
  }) : super(key: key);

  @override
  _ConfirmationPopUpState createState() => _ConfirmationPopUpState();
}

class _ConfirmationPopUpState extends State<ConfirmationPopUp> {
  bool _isImageView = true;

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
            color: Colors.black.withOpacity(0.6),
          ),
        ),
        // Positioned Container to move it up
        Positioned(
          top: screenHeight * 0.035, // Adjust this value to move the container up or down
          left: screenWidth * 0.1,
          right: screenWidth * 0.1,
          child: Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.65,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                if (_isImageView) ...[
                  // Image container with padding
                  Padding(
                    padding: const EdgeInsets.all(5.0), // Slight padding around the image
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners
                      child: Container(
                        width: double.infinity,
                        height: screenHeight * 0.6382,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(widget.imagePath)), // Load image from file
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: widget.isFrontCamera
                            ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(3.14159), // Mirror the image
                          child: Image.file(
                            File(widget.imagePath),
                            fit: BoxFit.cover,
                          ),
                        )
                            : Image.file(
                          File(widget.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Playlist details widget
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: PlaylistDetails(
                        playlistName: 'yappa',
                        songCount: 23,
                        playlistLink: 'kdsjfhlsdf',
                      ), // Display PlaylistDetails widget
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (_isImageView)
          Positioned(
            bottom: screenHeight * 0.15,
            left: screenWidth * 0.2,
            right: screenWidth * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Retake button (backward arrow)
                FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  onPressed: () {
                    Navigator.of(context).pop(); // Closes the pop-up
                    setState(() {
                      _isImageView = true;
                    });
                  },
                  child: Icon(
                    Icons.refresh,
                    size: 50,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                // Continue button (forward arrow)
                FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  onPressed: () {
                    Navigator.of(context).pop(); // Closes the pop-up
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistDetails(
                          playlistName: 'yappa',
                          songCount: 23,
                          playlistLink: 'kdsjfhlsdf',
                        ),
                      ),
                    );
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
