import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class RoundedTrianglePainter extends CustomPainter {
  final double borderRadius;
  final String mood; // Add mood parameter

  RoundedTrianglePainter({this.borderRadius = 10.0, required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    // Set the color based on the mood
    Color triangleColor;
    switch (mood.toLowerCase()) {
      case 'happy':
        triangleColor = Colors.yellow;
        break;
      case 'sad':
        triangleColor = Colors.blue;
        break;
      case 'angry':
        triangleColor = Colors.red;
        break;
      case 'surprised':
        triangleColor = Colors.orange;
        break;
      default:
        triangleColor = Colors.grey; // Default color if mood doesn't match
    }

    final Paint paint = Paint()
      ..color = triangleColor // Use the dynamic color
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    // Draw the triangle
    path.moveTo(width, height); // Bottom right corner
    path.lineTo(0, height); // Bottom left corner
    path.lineTo(width, 0); // Top right corner
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Return true so it repaints when mood changes
  }
}

class PlaylistRibbon extends StatefulWidget {
  final String imageUrl; // Add this parameter
  final String playlistName;
  final String mood;

  const PlaylistRibbon({
    super.key,
    required this.playlistName,
    required this.mood,
    required this.imageUrl, // Make this parameter required
  });

  @override
  _PlaylistRibbonState createState() => _PlaylistRibbonState();
}

class _PlaylistRibbonState extends State<PlaylistRibbon> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.9, // Adjust the width as needed
      height: screenHeight * 0.1, // Adjust the height as needed
      child: Stack(
        fit: StackFit.expand, // Ensure the Stack fills its parent Container
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
              child: CustomPaint(
                size: Size(screenHeight * 0.055, screenHeight * 0.055),
                painter: RoundedTrianglePainter(mood: widget.mood), // Pass the mood
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              child: Image.network(
                widget.imageUrl, // Use the image URL parameter
                fit: BoxFit.cover,
                width: screenHeight * 0.1, // Adjust width
                height: screenHeight * 0.1, // Adjust height
              ),
            ),
          ),
          Positioned(
              left: screenHeight * 0.13,
              top: screenHeight * 0.013,
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.playlistName,
                    style: TextStyle(
                      fontSize: screenHeight * 0.03,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    widget.mood,
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}
