import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

import 'expanded_playlist.dart';

class RoundedTrianglePainter extends CustomPainter {
  final double borderRadius;
  final String mood;

  RoundedTrianglePainter({this.borderRadius = 10.0, required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    path.moveTo(width, height);
    path.lineTo(0, height);
    path.lineTo(width, 0);
    path.close();

    if (mood.toLowerCase() == 'mixed') {
      // Create a rainbow gradient
      final Shader gradient = LinearGradient(
        colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple],
        stops: [0.0, 0.17, 0.33, 0.5, 0.67, 0.83, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

      paint.shader = gradient;
    } else {
      // Default colors for other moods
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
          triangleColor = Colors.grey;
      }

      paint.color = triangleColor;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PlaylistRibbon extends StatefulWidget {
  final String imageUrl;
  final String playlistName;
  final String mood;
  final String playlistLink;
  final bool isInExpandedPlaylist; // Add this parameter

  const PlaylistRibbon({
    super.key,
    required this.playlistName,
    required this.mood,
    required this.imageUrl,
    required this.playlistLink,
    this.isInExpandedPlaylist = false, // Default to false
  });

  @override
  _PlaylistRibbonState createState() => _PlaylistRibbonState();
}

class _PlaylistRibbonState extends State<PlaylistRibbon> {
  Future<void> _launchURL() async {
    final Uri url = Uri.parse(widget.playlistLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch ${widget.playlistLink}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        if (widget.isInExpandedPlaylist) {
          _launchURL(); // Open URL if in ExpandedPlaylist
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpandedPlaylist(
                playlistName: widget.playlistName,
                mood: widget.mood,
                imageUrl: widget.imageUrl,
                playlistLink: widget.playlistLink,
              ),
            ),
          );
        }
      },
      child: SizedBox(
        width: screenWidth * 0.9,
        height: screenHeight * 0.1,
        child: Stack(
          fit: StackFit.expand,
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
                  painter: RoundedTrianglePainter(mood: widget.mood),
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
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  width: screenHeight * 0.1,
                  height: screenHeight * 0.1,
                ),
              ),
            ),
            Positioned(
              left: screenHeight * 0.13,
              top: screenHeight * 0.013,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
