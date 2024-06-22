import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as spotify;

class SongRibon extends StatefulWidget {
  const SongRibon({
    Key? key,
  }) : super(key: key);

  @override
  _SongRibonState createState() => _SongRibonState();
}

class _SongRibonState extends State<SongRibon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 46, 51, 46), // Consistent color scheme
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    "Song Title",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    "Artist: Artist Name",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    "Album: Album Name",
                    style: TextStyle(
                      fontSize: 15,
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
