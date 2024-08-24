import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class RoundedTrianglePainter extends CustomPainter {
  final double borderRadius;

  RoundedTrianglePainter({this.borderRadius = 10.0});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue // Change the color as needed
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
    return false;
  }
}

class PlaylistRibbon extends StatefulWidget {
  final String imageUrl; // Add this parameter

  const PlaylistRibbon({
    super.key,
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
                painter: RoundedTrianglePainter(),
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
        ],
      ),
    );
  }
}
