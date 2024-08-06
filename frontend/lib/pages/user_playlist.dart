import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/components/playlist_ribon.dart';
import '../auth/auth_service.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<dynamic> playlists = [];

  @override
  void initState() {
    super.initState();
    _fetchSpotifyPlaylists();
  }

  Future<void> _fetchSpotifyPlaylists() async {
    final playlistData = await SpotifyAuth.fetchUserPlaylists();
    print('Spotify playlists fetched:');
    print(playlistData);
    if (playlistData != null) {
      setState(() {
        playlists = playlistData;
      });
    } else {
      setState(() {
        playlists = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
                  child: Text(
                    "My Playlists",
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Text(
                    "Recently Generated",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                // Display playlists dynamically
                ...playlists.map((playlist) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: PlaylistRibbon(
                      onTap: (playlistIcon) {
                        // Handle onTap action if needed
                        print('Tapped on playlist: ${playlist['name']}');
                      },
                      songCount: playlist['tracks']['total'],
                      playlistLink: playlist['id'],
                      playlistName: playlist['name'],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/camera');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/userprofile');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/audio');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/userplaylist');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/help');
              break;
          }
        },
      ),
    );
  }
}
