import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/components/playlist_details.dart';
import '../auth/auth_service.dart';

class PlaylistRibbon extends StatefulWidget {
  final Function(int) onTap;
  final int songCount;
  final String playlistLink;
  final String playlistName;
  final bool isFullSize; // New boolean parameter

  const PlaylistRibbon({
    Key? key,
    required this.onTap,
    required this.songCount,
    required this.playlistLink,
    required this.playlistName,
    this.isFullSize = false, // Default to false if not provided
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
    final playlistIcon;
    List<Color> gradientColors;
    Color borderColor;

    if (mood == 'Happy') {
      playlistIcon = SvgPicture.asset(
        'assets/icons/Open_Up.svg',
        width: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      );
    } else if (mood == 'Sad') {
      playlistIcon = SvgPicture.asset(
        'assets/icons/Sad_Down.svg',
        width: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      );
    } else if (mood == 'Angry') {
      playlistIcon = SvgPicture.asset(
        'assets/icons/Angry_Down.svg',
        width: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      );
    } else if (mood == 'Surprised') {
      playlistIcon = SvgPicture.asset(
        'assets/icons/Open_O.svg',
        width: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      );
    } else {
      playlistIcon = SvgPicture.asset(
        'assets/icons/Open_Norm.svg',
        width: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      );
    }

    return GestureDetector(
      onTap: () {
        _handleTap(playlistIcon);
      },
      child: Container(
        width: widget.isFullSize ? double.infinity : null,
        height: widget.isFullSize ? double.infinity : 140,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 25,
              top: 20,
              child: Container(
                child: playlistIcon,
              ),
            ),
            Align(
              alignment: widget.isFullSize ? Alignment.topLeft : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  25,
                  widget.isFullSize ? 20 : 0,
                  20,
                  widget.isFullSize ? 10 : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  mainAxisAlignment: widget.isFullSize
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center, // Align items to the top or center based on size
                  children: [
                    Text(
                      widget.playlistName,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Mood: $mood",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Song Count: ${widget.songCount}",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.left, // Align text to the left
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
