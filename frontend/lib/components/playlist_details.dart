import 'package:flutter/material.dart';
import 'package:frontend/components/playlist_ribon.dart';
import 'package:frontend/components/song_ribon.dart';
import 'package:spotify/spotify.dart' as spotify;

class PlaylistDetails extends StatefulWidget {
  final String playlistName;
  final int songCount;
  final String playlistLink;

  const PlaylistDetails({
    super.key,
    required this.playlistName,
    required this.songCount,
    required this.playlistLink,
  });

  @override
  _PlaylistDetailsState createState() => _PlaylistDetailsState();
}

class _PlaylistDetailsState extends State<PlaylistDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: PlaylistRibbon(

        ),
      ),
    );
  }
}
