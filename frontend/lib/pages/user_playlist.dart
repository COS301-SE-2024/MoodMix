import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/components/playlist_ribon.dart';
import '../auth/auth_service.dart';
import '../components/custom_scrollbar.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<dynamic> playlists = [];
  bool isLoading = true;
  bool isFadeOut = false;

  @override
  void initState() {
    super.initState();
    _fetchSpotifyPlaylists();
  }

  Future<void> _fetchSpotifyPlaylists() async {
    String? userId = SpotifyAuth.getUserId();

    try {
      final playlistData = await SpotifyAuth.fetchUserPlaylists(userId);
      print("Playlist Data being returned is as follows:");
      print(playlistData);
      if (playlistData != null) {
        setState(() {
          playlists = playlistData.map((playlist) {
            final firstImageUrl = playlist['images'].isNotEmpty
                ? playlist['images'][0]['url']
                : '';
            return {
              'name': playlist['name'],
              'image': firstImageUrl,
              'url': playlist['external_urls']['spotify'],
              'mood': playlist['mood'],
            };
          }).toList();
        });
      } else {
        setState(() {
          playlists = [];
        });
      }
    } finally {
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isFadeOut = true;
        });
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            isLoading = false;
          });
        });
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
              visible: !isLoading,
              child: playlists.isEmpty
                  ? Center(
                child: Text(
                  'No playlists available.',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              )
                  : FlashingScrollbarWidget(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        "My playlists",
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      SizedBox(height: 10),
                      ...playlists.map((playlist) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: PlaylistRibbon(
                            playlistName: playlist['name'],
                            mood: playlist['mood'],
                            imageUrl: playlist['image'],
                            playlistLink: playlist['url'],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: isLoading ? 1.0 : isFadeOut ? 0.0 : 1.0,
              duration: Duration(milliseconds: 300),
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
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
              Navigator.pushReplacementNamed(context, '/userplaylist');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/userprofile');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }
}
