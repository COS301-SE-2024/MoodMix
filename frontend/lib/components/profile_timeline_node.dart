import 'package:flutter/material.dart';

class ProfileTimelineNode extends StatefulWidget {
  final String title;
  final String mood;
  final String date;
  final double alignOffset; // Add this parameter
  final double scale;

  const ProfileTimelineNode({
    Key? key,
    required this.title,
    required this.mood,
    required this.date,
    required this.alignOffset, // Add this parameter
    required this.scale,
  }) : super(key: key);

  @override
  _ProfileTimelineNodeState createState() => _ProfileTimelineNodeState();
}

class _ProfileTimelineNodeState extends State<ProfileTimelineNode> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    late IconData iconMood;
    if (widget.mood == 'Happy') {
      iconMood = Icons.mood;
    } else if (widget.mood == 'Sad') {
      iconMood = Icons.mood_bad;
    } else if (widget.mood == 'Angry') {
      iconMood = Icons.block;
    } else {
      iconMood = Icons.block;
    }

    return Opacity(
      opacity: 0.7,
      child: Container(
        margin: EdgeInsets.only(left: widget.alignOffset), // Use the alignOffset to set the left margin
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Center align the row contents
          children: [
            Column(
              children: [
                Container(
                  // height: 120.0 * widget.scale, // Adjust the height as needed
                  child: Column(
                    children: [
                      Container(
                        width: 2.0 * widget.scale,
                        height: 40.0 * widget.scale, // Height from the top to the icon
                        color: Colors.grey, // Line color
                      ),
                      Icon(
                        iconMood, // Replace with your desired icon
                        size: 80.0 * widget.scale, // Adjust the size as needed
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.0), // Space between icon/line and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 37.0 * widget.scale), // Space between icon/line and text
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 16.0 * widget.scale / 2), // Adjust the style as needed
                ),
                SizedBox(height: 8.0), // Space between the text boxes
                Text(
                  widget.date,
                  style: TextStyle(fontSize: 16.0 * widget.scale / 2), // Adjust the style as needed
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
