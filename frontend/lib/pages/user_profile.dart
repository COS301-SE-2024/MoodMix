import 'package:flutter/material.dart';
import 'package:frontend/components/profile_timeline_node.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../auth/auth_service.dart';
import 'package:frontend/components/navbar.dart'; // Import your new bottom navbar component
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? _displayName = '';
  String? _spotifyUsername = '';
  String? _spotifyProfileImage = '';
  List<String> _playlistNames = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchSpotifyUserDetails();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService().getCurrentUser();
    if (user != null) {
      setState(() {
        _displayName = user.displayName;
      });
    }
  }

  Future<void> _fetchSpotifyUserDetails() async {
    final spotifyUserDetails = await AuthService().getSpotifyUserDetails();
    if (spotifyUserDetails != null) {
      setState(() {
        _spotifyUsername = spotifyUserDetails['display_name'];
        _spotifyProfileImage = spotifyUserDetails['images'] != null && spotifyUserDetails['images'].isNotEmpty
            ? spotifyUserDetails['images'][0]['url']
            : '';
        // Fetch and set playlist names if available
        _playlistNames = spotifyUserDetails['playlists'] != null 
            ? List<String>.from(spotifyUserDetails['playlists'].map((playlist) => playlist['name']))
            : [];
      });
    }
  }

  Future<void> _changeUsername(String newDisplayName) async {
    final user = await AuthService().getCurrentUser();
    if (user != null) {
      try {
        await user.updateDisplayName(newDisplayName);
        setState(() {
          _displayName = newDisplayName;
        });
      } catch (e) {
        print("Failed to update username: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: CircleAvatar(
                    backgroundImage: _spotifyProfileImage != null 
                        ? NetworkImage(_spotifyProfileImage!) 
                        : AssetImage('assets/images/images.jpeg') as ImageProvider,
                    backgroundColor: Colors.transparent,
                    radius: screenHeight / 10,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      '$_displayName',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      _spotifyUsername ?? 'Loading...',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(left: screenHeight / 10 - 15),
                children: _playlistNames.map((name) => ProfileTimelineNode(
                  title: name,
                  mood: "Unknown", // You can replace this with actual data if available
                  date: "Unknown", // You can replace this with actual data if available
                )).toList(),
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
