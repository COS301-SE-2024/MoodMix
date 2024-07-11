import 'package:flutter/material.dart';

class ProfileTimelineNode extends StatefulWidget {
  final String title;
  final String mood;
  final String date;

  const ProfileTimelineNode({
    Key? key,
    required this.title,
    required this.mood,
    required this.date,
  }) : super(key: key);

  @override
  _ProfileTimelineNodeState createState() => _ProfileTimelineNodeState();
}

class _ProfileTimelineNodeState extends State<ProfileTimelineNode> {
  @override
  Widget build(BuildContext context) {

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

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Center align the row contents
        children: [
          Column(
            children: [
              Container(
                height: 120.0, // Adjust the height as needed
                child: Column(
                  children: [
                    Container(
                      width: 2.0,
                      height: 40.0, // Height from the top to the icon
                      color: Colors.grey, // Line color
                    ),
                    Icon(
                      iconMood, // Replace with your desired icon
                      size: 80.0, // Adjust the size as needed
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 16.0), // Space between icon/line and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Center align the text column
            children: [
              SizedBox(height: 40.0, width: 10,), // Space between icon/line and text
              Text(
                widget.title,
                style: TextStyle(fontSize: 16.0), // Adjust the style as needed
              ),
              SizedBox(height: 8.0), // Space between the text boxes
              Text(
                widget.date,
                style: TextStyle(fontSize: 16.0), // Adjust the style as needed
              ),
            ],
          ),
        ],
      ),
    );
  }
}
