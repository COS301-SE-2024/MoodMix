import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/components/playlist_details.dart';
import '../auth/auth_service.dart';

class PlaylistRibbon extends StatefulWidget {
  final Function(int) onTap;
  final int songCount;
  final String playlistLink;
  final String playlistName;

  const PlaylistRibbon({
    Key? key,
    required this.onTap,
    required this.songCount,
    required this.playlistLink,
    required this.playlistName,
  }) : super(key: key);

  @override
  _PlaylistRibbonState createState() => _PlaylistRibbonState();
}

class _PlaylistRibbonState extends State<PlaylistRibbon> {
  String mood = 'Unknown'; // Class member variable to store mood

  @override
  void initState() {
    super.initState();
    _fetchAndDisplayMood();
  }

  void _fetchAndDisplayMood() async {
    String fetchedMood = await SpotifyAuth.calculateAggregateMood(widget.playlistLink);
    setState(() {
      mood = fetchedMood; // Update the mood state
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final playlistIcon;

    List<Color> gradientColors;
    print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
    print(mood);
    print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
    if (mood == 'Happy') {
      gradientColors = [
        Color.fromARGB(255, 18, 85, 20),
        Color.fromARGB(221, 62, 239, 76)
      ];
      playlistIcon = SvgPicture.asset(
        'assets/icons/Open_Up.svg',
        width: 100,
        color: Color.fromARGB(255, 18, 85, 20),
      );
    } else if (mood == 'Sad') {
      gradientColors = [
        Color.fromARGB(255, 18, 27, 85),
        Color.fromARGB(221, 62, 118, 239)
      ];
      playlistIcon = SvgPicture.asset(
        'assets/icons/Sad_Down.svg',
        width: 100,
        color: Color.fromARGB(255, 18, 27, 85),
      );
    } else if (mood == 'Angry') {
      gradientColors = [
        Color.fromARGB(255, 85, 18, 18),
        Color.fromARGB(221, 239, 62, 62)
      ];
      playlistIcon = SvgPicture.asset(
        'assets/icons/Angry_Down.svg',
        width: 100,
        color: Color.fromARGB(255, 85, 18, 18),
      );
    } else if (mood == 'Surprised') {
      gradientColors = [
        Color.fromARGB(255, 110, 7, 126),
        Color.fromARGB(221, 215, 62, 239)
      ];
      playlistIcon = SvgPicture.asset(
        'assets/icons/Open_O.svg',
        width: 100,
        color: Color.fromARGB(255, 110, 7, 126),
      );
    } else {
      gradientColors = [
        Color.fromARGB(255, 5, 1, 1),
        Color.fromARGB(221, 151, 133, 133)
      ];
      playlistIcon = SvgPicture.asset(
        'assets/icons/Open_Norm.svg',
        width: 100,
        color: Color.fromARGB(255, 5, 1, 1),
      );;
    }

    return GestureDetector(
      onTap: () {
        _handleTap(playlistIcon);
      },
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 25,
              top: 10,
              bottom: 10,
              child: Container(
                child: playlistIcon,
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(25, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.playlistName,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Mood: $mood",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Song Count: ${widget.songCount}",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(String pIcon) {
    // Implement your handle tap logic here
  }
}
