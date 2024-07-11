import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as spotify;
import 'package:frontend/components/model.dart'; // Import your Dart models

class SongRibbon extends StatefulWidget {
  final String playlistLink;
  final spotify.SpotifyApi api;

  const SongRibbon({
    Key? key,
    required this.playlistLink,
    required this.api,
  }) : super(key: key);

  @override
  _SongRibbonState createState() => _SongRibbonState();
}

class _SongRibbonState extends State<SongRibbon> {
  List<dynamic>? tracks; // Declare tracks as nullable

  @override
  void initState() {
    super.initState();
    _fetchSpotifyData();
  }

  Future<void> _fetchSpotifyData() async {
    try {
      var playlist = await widget.api.playlists.get(widget.playlistLink);
      setState(() {
        tracks = playlist.tracks?.itemsNative?.toList(); // Convert itemsNative to a List
      });
    } catch (error) {
      print(error);
      setState(() {
        tracks = []; // Set tracks to an empty list on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return tracks == null
        ? Center(child: CircularProgressIndicator())
        : tracks!.isEmpty
            ? Center(child: Text('No tracks found', style: TextStyle(color: Theme.of(context).colorScheme.secondary)))
            : ListView.builder(
                shrinkWrap: true, // Important for sizing
                physics: NeverScrollableScrollPhysics(), // Prevents scrolling
                itemCount: tracks!.length,
                itemBuilder: (context, index) {
                  var trackData = tracks![index]; // Access track data from List
                  var track = Track.fromJson(trackData['track'] ?? {});
                  return ListTile(
                    // leading: track.album.images.isNotEmpty
                    //     ? Image.network(
                    //         track.album.images.first.url,
                    //         height: 50,
                    //         width: 50,
                    //         fit: BoxFit.cover,
                    //       )
                    //     : Icon(Icons.music_note, size: 50, color: Colors.white),
                    title: Text(
                      track.name,
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 18),
                    ),
                    subtitle: Text(
                      track.artists.map((artist) => artist.name).join(', '),
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 14),
                    ),
                    onTap: () {
                      // Implement onTap functionality if needed
                    },
                  );
                },
              );
  }
}
