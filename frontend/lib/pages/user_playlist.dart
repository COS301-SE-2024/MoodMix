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
  bool isLoading = true;
  bool isFadeOut = false;

  @override
  void initState() {
    super.initState();
    _fetchSpotifyPlaylists();
  }

  Future<void> _fetchSpotifyPlaylists() async {
    try {
      final playlistData = await SpotifyAuth.fetchUserPlaylists();
      if (playlistData != null) {
        setState(() {
          playlists = playlistData;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
              visible: !isLoading,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
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
                      // ...playlists.map((playlist) {
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: PlaylistRibbon(
                          ),
                        ),

                    ],
                  ),
                ),
              ),
            ),
            // Loading indicator
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
