import 'package:flutter/material.dart';
import 'package:frontend/components/playlist_ribon.dart';
import 'package:frontend/components/song_ribon.dart';
// Add this import for opening URLs

import '../auth/auth_service.dart';

class ExpandedPlaylist extends StatefulWidget {
  final String playlistName;
  final String mood;
  final String imageUrl;
  final String playlistLink;

  const ExpandedPlaylist({
    super.key,
    required this.playlistName,
    required this.mood,
    required this.imageUrl,
    required this.playlistLink,
  });

  @override
  _ExpandedPlaylistState createState() => _ExpandedPlaylistState();
}

class _ExpandedPlaylistState extends State<ExpandedPlaylist> {
  List<dynamic>? tracks;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaylistTracks();
  }

  String extractPlaylistId(String playlistLink) {
    final uri = Uri.parse(playlistLink);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      return pathSegments.last;
    }
    throw ArgumentError('Invalid playlist link: $playlistLink');
  }

  Future<void> _loadPlaylistTracks() async {
    final playlistId = extractPlaylistId(widget.playlistLink);
    final playlistData = await SpotifyAuth.fetchPlaylistTracks(playlistId);

    if (playlistData != null && playlistData['items'] != null) {
      setState(() {
        tracks = playlistData['items'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist Information'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: PlaylistRibbon(
              playlistName: widget.playlistName,
              mood: widget.mood,
              imageUrl: widget.imageUrl,
              playlistLink: widget.playlistLink,
              isInExpandedPlaylist: true,
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tracks?.length ?? 0,
            itemBuilder: (context, index) {
              final track = tracks![index]['track'];
              return SongRibbon(
                songName: track['name'],
                artistName: track['artists'][0]['name'],
                imageUrl: track['album']['images'][0]['url'],
                trackUrl: track['external_urls']['spotify'],
              );
            },
          ),
        ],
      ),
    );
  }
}
