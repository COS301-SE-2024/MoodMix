import 'package:flutter/material.dart';
import 'package:frontend/components/song_ribon.dart';
import 'package:spotify/spotify.dart' as spotify;

class PlaylistDetails extends StatefulWidget {
  final spotify.SpotifyApi api;
  final String playlistIcon;
  final String playlistLink;
  final String mood;
  final int songCount;

  const PlaylistDetails({
    Key? key,
    required this.playlistIcon,
    required this.api,
    required this.playlistLink,
    required this.mood,
    required this.songCount,
  }) : super(key: key);

  @override
  _PlaylistDetailsState createState() => _PlaylistDetailsState();
}

class _PlaylistDetailsState extends State<PlaylistDetails> {
  String playlistName = "Loading...";
  int songCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchSpotifyData();
  }

  Future<void> _fetchSpotifyData() async {
    try {
      var playlist = await widget.api.playlists.get(widget.playlistLink);
      setState(() {
        playlistName = playlist.name!;
        songCount = playlist.tracks!.total;
      });
    } catch (error) {
      setState(() {
        playlistName = "Error loading playlist";
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 41, 36),
      appBar: AppBar(
        title: Text('Playlist Details'),
        backgroundColor: Color.fromARGB(255, 16, 17, 16),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    widget.playlistIcon,
                    fit: BoxFit.cover,
                    height: 130,
                    width: 130,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlistName,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Mood: ${widget.mood}",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Song Count: $songCount",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Add SongRibbon here
              SongRibbon(playlistLink: widget.playlistLink, api: widget.api),
              SizedBox(height: 20), // Add some bottom spacing if needed
            ],
          ),
        ),
      ),
    );
  }
}
