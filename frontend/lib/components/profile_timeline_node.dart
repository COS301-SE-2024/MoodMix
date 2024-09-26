import 'package:flutter/material.dart';

class ProfileTimelineNode extends StatelessWidget {
  final String title;
  final String mood;
  final String date;
  final double alignOffset;
  final double scale;

  const ProfileTimelineNode({
    super.key,
    required this.title,
    required this.mood,
    required this.date,
    required this.alignOffset,
    required this.scale,
  });

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'happy':
        return Colors.yellow; // Yellow for happy mood
      case 'sad':
        return Colors.blue; // Blue for sad mood
      case 'angry':
        return Colors.red; // Red for angry mood
      default:
        return Colors.grey; // Default color for unknown mood
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodColor = _getMoodColor(mood);
    final moodCircleSize = 80.0 * scale;
    const margin = 16.0; // Space between circle and text

    return Opacity(
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.8,
                      colors: [moodColor.withOpacity(0.9), moodColor.withOpacity(0.6)],
                      stops: [0.5, 1.0],
                    ),
                  ),
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
    );
  }
}
