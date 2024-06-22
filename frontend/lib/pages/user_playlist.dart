import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/components/playlist_ribon.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
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
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
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
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: PlaylistRibbon(
                    currentIndex: 0,
                    onTap: (index) {
                      print('Tapped on index: $index');
                    },
                    mood: 'Happy',
                    songCount: 10,
                    playlistLink: '37i9dQZF1EIgG2NEOhqsD7?si=0bd9af73b1294d0e',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Text(
                    "Saved Playlists",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: PlaylistRibbon(
                    currentIndex: 0,
                    onTap: (index) {
                      print('Tapped on index: $index');
                    },
                    mood: 'Sad',
                    songCount: 10,
                    playlistLink: '37i9dQZF1EIdChYeHNDfK5?si=24280582960a4173',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: PlaylistRibbon(
                    currentIndex: 0,
                    onTap: (index) {
                      print('Tapped on index: $index');
                    },
                    mood: 'Angry',
                    songCount: 10,
                    playlistLink: '37i9dQZF1EIgNZCaOGb0Mi?si=f0985e4d1cf14fa4',
                  ),
                ),
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
              Navigator.pushReplacementNamed(context, '/homepage');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/userprofile');
              break;
            case 2:
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/userplaylist');
              break;
          }
        },
      ),
    );
  }
}
