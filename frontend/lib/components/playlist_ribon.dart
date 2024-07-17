import 'package:flutter/material.dart';
import 'package:frontend/components/playlist_details.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlaylistRibbon extends StatefulWidget {
  final Function(int) onTap;
  final String mood;
  final int songCount;
  final String playlistLink;
  final String playlistName;

  const PlaylistRibbon({
    Key? key,
    required this.onTap,
    required this.mood,
    required this.songCount,
    required this.playlistLink,
    required this.playlistName,
  }) : super(key: key);

  @override
  _PlaylistRibbonState createState() => _PlaylistRibbonState();
}

class _PlaylistRibbonState extends State<PlaylistRibbon> {

  @override
  void initState() {
    super.initState();
  }

  // Function to handle tap event
  void _handleTap(String pIcon) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PlaylistDetails(
    //       playlistIcon: pIcon,
    //       api: spotifyApi,
    //       playlistLink: widget.playlistLink,
    //       mood: widget.mood,
    //       songCount: widget.songCount,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final playlistIcon;

    Color containerColor;
    if (widget.mood == 'Happy') {
      containerColor = Theme.of(context).colorScheme.tertiary;
      playlistIcon = 'assets/images/happy_playlist_icon.png';
    } else if (widget.mood == 'Sad') {
      containerColor = Theme.of(context).colorScheme.tertiary;
      playlistIcon = 'assets/images/sad_playlist_icon.png';
    } else if (widget.mood == 'Angry') {
      containerColor = Theme.of(context).colorScheme.tertiary;
      playlistIcon = 'assets/images/angry_playlist_icon.png';
    } else {
      containerColor = Colors.grey;
      playlistIcon = 'assets/images/sad_playlist_icon.png';
    }

    return GestureDetector(
      onTap: () {
        _handleTap(playlistIcon);
      },
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Image.asset(
                playlistIcon,
                fit: BoxFit.cover,
                height: 130,
                width: 130,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      widget.playlistName,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      "Mood: ${widget.mood}",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      "Song Count: ${widget.songCount}",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      textAlign: TextAlign.left,
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
