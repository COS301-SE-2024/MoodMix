import 'package:flutter/material.dart';
import 'package:frontend/components/playlist_details.dart';
import 'package:spotify/spotify.dart' as spotify;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlaylistRibbon extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String mood;
  final int songCount;
  final String playlistLink;

  const PlaylistRibbon({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.mood,
    required this.songCount,
    required this.playlistLink,
  }) : super(key: key);

  @override
  _PlaylistRibbonState createState() => _PlaylistRibbonState();
}

class _PlaylistRibbonState extends State<PlaylistRibbon> {
  late spotify.SpotifyApi spotifyApi;
  String playlistName = "Loading...";
  String mood = "Unknown Mood";
  int songCount = 0;
  late Iterable<dynamic>? tracks;

  @override
  void initState() {
    super.initState();

    final clientId = dotenv.env['SPOTIFY_CLIENT_ID'];
    final clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET'];
    final credentials = spotify.SpotifyApiCredentials(clientId!, clientSecret!);
    spotifyApi = spotify.SpotifyApi(credentials);

    _fetchSpotifyData();
  }

  Future<void> _fetchSpotifyData() async {
    try {
      var playlist = await spotifyApi.playlists.get(widget.playlistLink);
      setState(() {
        playlistName = playlist.name!;
        tracks = playlist.tracks?.itemsNative;
        for (var temp in tracks!) {
          // print(temp);
        }
        songCount = playlist.tracks!.total;
      });
    } catch (error) {
      setState(() {
        playlistName = "Error loading playlist";
      });
      print(error);
    }
  }

  // Function to handle tap event
  void _handleTap(String pIcon) {
    // You can navigate to another screen or perform an action here
    // For example, navigate to a new route passing some data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistDetails(
          playlistIcon: pIcon,
          api: spotifyApi,
          playlistLink: widget.playlistLink,
          mood: widget.mood,
          songCount: widget.songCount,
        ),
      ),
    );
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
      containerColor =
          Colors.grey; // Default color if mood doesn't match any case
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
                      playlistName,
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
                      "Song Count: $songCount",
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
