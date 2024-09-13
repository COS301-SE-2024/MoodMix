import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileTimelineNode extends StatelessWidget {
  final String title;
  final String mood;
  final String date;
  final double alignOffset;
  final double scale;
  final String link;

  const ProfileTimelineNode({
    Key? key,
    required this.title,
    required this.mood,
    required this.date,
    required this.alignOffset,
    required this.scale,
    required this.link,
  }) : super(key: key);

  BoxDecoration _getMoodDecoration(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.yellow.shade300, Colors.yellow.shade800],
            stops: [0.0, 1.0],
          ),
        );
      case 'sad':
        return BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade800],
            stops: [0.0, 1.0],
          ),
        );
      case 'angry':
        return BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.red.shade300, Colors.red.shade800],
            stops: [0.0, 1.0],
          ),
        );
      case 'mixed':
        return BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green,
              Colors.blue,
              Colors.indigo,
              Colors.purple
            ],
            stops: [0.0, 0.17, 0.33, 0.5, 0.67, 0.83, 1.0],
          ),
        );
      default:
        return BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.grey.shade800],
            stops: [0.0, 1.0],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodDecoration = _getMoodDecoration(mood);
    final moodCircleSize = 80.0 * scale;
    final margin = 16.0; // Space between circle and text

    return GestureDetector(
      onTap: () async {
        Uri _url = Uri.parse(link);
        if (!await launchUrl(_url)) {
        throw 'Could not launch $_url';
        }
      },
      child: Opacity(
        opacity: 0.7,
        child: Container(
          margin: EdgeInsets.only(left: alignOffset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Divider line
              Padding(
                padding: EdgeInsets.only(left: 80.0 * scale / 2),
                child: Container(
                  width: 2.0 * scale,
                  height: 40.0 * scale,
                  color: Colors.grey, // Line color
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Mood circle
                  Container(
                    width: moodCircleSize,
                    height: moodCircleSize,
                    decoration: moodDecoration,
                  ),
                  SizedBox(width: margin),
                  // Text column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title text
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 30.0 * scale / 2,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.0),
                        // Date text
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 25.0 * scale / 2,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}