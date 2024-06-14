import 'package:flutter/material.dart';

class PlaylistRibon extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String mood;
  final int songCount;

  const PlaylistRibon({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.mood,
    required this.songCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Color containerColor;
    if (mood == 'Happy') {
      containerColor = Colors.green;
    } else if (mood == 'Sad') {
      containerColor = Color.fromARGB(255, 6, 14, 78);
    } else if (mood == 'Angry') {
      containerColor = Colors.red;
    } else {
      containerColor = Colors.grey; // Default color if mood doesn't match any case
    }

    return Container(
      height: 150,

      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),

      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Image(
              image: AssetImage('assets/images/sad_playlist_icon.png'),
              fit: BoxFit.cover,
              height: 140,
              width: 140,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Playlist name",
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Mood: $mood",
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Song Count: $songCount",
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
