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
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Center(
          child: Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.85,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Container for rounded AppBar
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Theme.of(context).colorScheme.tertiary,
                          onPressed: () {
                            Navigator.of(context).pop(); // Closes the pop-up
                          },
                        ),
                        title: Text(
                          _isImageView ? widget.mood : 'Playlist Details',
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        centerTitle: true,
                      ),
                    ],
                  ),
                ),
                if (_isImageView) ...[
                  // Image container with padding
                  Padding(
                    padding: const EdgeInsets.all(20.0), // Padding around the image
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners
                      child: Container(
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.55,
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
                  // Spacer to push buttons to the bottom
                  Spacer(),
                  // Retake button
                  Container(
                    width: screenWidth * 0.7,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        Navigator.of(context).pop(); // Closes the pop-up
                        setState(() {
                          _isImageView = true;
                        });
                      },
                      label: Text(
                        'Retake',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.tertiary,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Continue button
                  Container(
                    width: screenWidth * 0.7,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        setState(() {
                          _isImageView = false;
                        });
                      },
                      label: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.tertiary,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ] else ...[
                  // Playlist details widget
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: PlaylistDetails(), // Display PlaylistDetails widget
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
