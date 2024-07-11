import 'package:flutter/material.dart';
import 'package:frontend/components/profile_timeline_node.dart';
import 'package:frontend/theme/theme_provider.dart';
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
    final spotifyUserDetails = await AuthService().getCurrentUser();
    if (spotifyUserDetails != null) {
      setState(() {
        _spotifyUsername = spotifyUserDetails.displayName;
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
        // Optionally, you can show a success message to the user here
      } catch (e) {
        // Handle error
        print("Failed to update username: $e");
        // Optionally, you can show an error message to the user here
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
                    backgroundImage: AssetImage('assets/images/images.jpeg'),
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
                padding: EdgeInsets.only(
                    left: screenHeight / 10 -
                        15), // Adjust left padding to match the avatar radius
                children: [
                  ProfileTimelineNode(
                    title: "Test Playlist One",
                    mood: "Happy",
                    date: "12/02/2024",
                  ),
                  ProfileTimelineNode(
                    title: "Test Playlist Two",
                    mood: "Sad",
                    date: "12/02/2024",
                  ),
                  ProfileTimelineNode(
                    title: "Test Playlist Three",
                    mood: "Angry",
                    date: "12/02/2024",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        // Replace bottomNavigationBar with your BottomNavbar component
        currentIndex: 1, // Set current index accordingly
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
