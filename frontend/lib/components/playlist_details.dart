import 'package:flutter/material.dart';
import 'package:frontend/components/playlist_ribon.dart';
import 'package:frontend/components/song_ribon.dart';
import 'package:spotify/spotify.dart' as spotify;

class PlaylistDetails extends StatefulWidget {

  const PlaylistDetails({
    Key? key,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: PlaylistRibbon(
        onTap: (playlistIcon) {
          // Handle onTap action if needed
          print('Tapped on playlist: ');
        },
        songCount: 12,
        playlistLink: '12123231',
        playlistName: 'dsfsdfsdf',
        isFullSize: true,
      ),
    );
  }
}
