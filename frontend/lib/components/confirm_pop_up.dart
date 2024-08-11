import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/mood_service.dart';
import 'playlist_details.dart';

class ConfirmationPopUp extends StatefulWidget {
  final String? imagePath;
  final String? transcribedText;
  final bool isFrontCamera;
  final String mood;
  final bool isImage;

  const ConfirmationPopUp({
    Key? key,
    this.imagePath,
    this.transcribedText,
    required this.mood,
    this.isFrontCamera = false,
    this.isImage = true,
  }) : super(key: key);

  @override
  _ConfirmationPopUpState createState() => _ConfirmationPopUpState();
}

class _ConfirmationPopUpState extends State<ConfirmationPopUp> {
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
        // Positioned Container to move it up
        Positioned(
          top: screenHeight * 0.035,
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
                if (widget.isImage && widget.imagePath != null) ...[
                  // Image container with padding
                  Padding(
                    padding: const EdgeInsets.all(6.5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: double.infinity,
                        height: screenHeight * 0.63, // Dynamically adjust this to fill the container
                        child: widget.isFrontCamera
                            ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(3.14159), // Mirror the image
                          child: Image.file(
                            File(widget.imagePath!),
                            fit: BoxFit.cover, // Ensure the image fills the container
                          ),
                        )
                            : Image.file(
                          File(widget.imagePath!),
                          fit: BoxFit.cover, // Ensure the image fills the container
                        ),
                      ),
                    ),
                  ),
                ] else if (!widget.isImage && widget.transcribedText != null) ...[
                  // Display transcribed text for audio confirmation
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.transcribedText!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ] else ...[
                  // Playlist details widget
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: PlaylistDetails(
                        playlistName: "MoodMix for ${SpotifyAuth.currentUser?.displayName} - ${MoodService().mood}",
                        songCount: 23,
                        playlistLink: 'kdsjfhlsdf',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (widget.isImage || widget.transcribedText != null)
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
                          playlistName: 'MoodMix for ${SpotifyAuth.currentUser?.displayName} - ${MoodService().mood}',
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
