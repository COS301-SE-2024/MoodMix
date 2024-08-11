import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/components/playlist_details.dart';
import 'package:frontend/components/song_ribon.dart';
import 'package:frontend/mood_service.dart';
import '../auth/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:frontend/neural_net/neural_net_method_channel.dart';
import 'package:frontend/pages/camera.dart';


class PlaylistRibbon extends StatefulWidget {
  final Function(int) onTap;
  final int songCount;
  final String playlistLink;
  final String playlistName;
  final bool isFullSize;

  const PlaylistRibbon({
    Key? key,
    required this.onTap,
    required this.songCount,
    required this.playlistLink,
    required this.playlistName,
    this.isFullSize = false,
  }) : super(key: key);

  @override
  _PlaylistRibbonState createState() => _PlaylistRibbonState();
}

class _PlaylistRibbonState extends State<PlaylistRibbon> {
  String mood = 'Unknown';
  bool isMoodLoading = true; // Track loading state for mood
  static String playlistMood = "";

  @override
  void initState() {
    super.initState();
    _fetchAndDisplayMood();

  }

  Future<void> _fetchMood() async {
    // Fetch the mood stored in camera.dart
    setState(() {
      playlistMood = MoodService().mood;
      mood = playlistMood;// Adjust the call as needed
    });
  }

  Future<void> _fetchAndDisplayMood() async {
    try {
      // final fetchedMood = await SpotifyAuth.calculateAggregateMood(widget.playlistLink);
      // setState(() {
      //   mood = fetchedMood;
      // });
      await _fetchMood();

    } catch (e) {
      print('Error fetching mood: $e');
      setState(() {
        mood = 'Unknown'; // Handle error scenario
      });
    } finally {
      setState(() {
        isMoodLoading = false; // Update loading state after fetching
      });
    }
  }

  void _handleTap() {
    if (!widget.isFullSize) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlaylistDetails(
            playlistName: widget.playlistName,
            songCount: widget.songCount,
            playlistLink: widget.playlistLink,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlistIcon = _getPlaylistIcon();
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: widget.isFullSize ? double.infinity : null,
        height: widget.isFullSize ? double.infinity : 140,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          borderRadius: widget.isFullSize ? BorderRadius.zero : BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            if (isMoodLoading)
              Center(
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
              )
            else ...[
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
                  child: widget.isFullSize
                      ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          overflow: TextOverflow.ellipsis, // Add this
                          maxLines: 1, // Add this
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
                          textAlign: TextAlign.left,
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
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        SongRibbon(),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            _buildButton('Discard', screenWidth),
                            SizedBox(height: 10),
                            _buildButton('Regenerate', screenWidth),
                            SizedBox(height: 10),
                            _buildButton('Save Playlist', screenWidth),
                          ],
                        ),
                      ],
                    ),
                  )
                      : Column(
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
                        overflow: TextOverflow.ellipsis, // Add this
                        maxLines: 1, // Add this
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
                        textAlign: TextAlign.left,
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
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  SvgPicture _getPlaylistIcon() {
    if (mood == 'happy') {
      return SvgPicture.asset(
        'assets/icons/Open_Up.svg',
        width: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      );
    } else if (mood == 'sad') {
      return SvgPicture.asset(
        'assets/icons/Sad_Down.svg',
        width: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      );
    } else if (mood == 'angry') {
      return SvgPicture.asset(
        'assets/icons/Angry_Down.svg',
        width: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      );
    } else if (mood == 'neutral') {
      return SvgPicture.asset(
        'assets/icons/Open_O.svg',
        width: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      );
    } else {
      return SvgPicture.asset(
        'assets/icons/Open_Norm.svg',
        width: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      );
    }
  }

  Widget _buildButton(String text, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: screenWidth * 0.9,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: () {
            if (text == "Discard") {
              Navigator.pushReplacementNamed(context, '/camera');
            } else if (text == "Regenerate") {
              // Handle regenerate action
            } else if (text == "Save Playlist") {
               SpotifyAuth.createAndPopulatePlaylistWithRecommendations(
              'MoodMix Playlist ',
               mood
              );
              Navigator.pushReplacementNamed(context, '/userplaylist');
            }
          },
          child: Text(
            text,
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
