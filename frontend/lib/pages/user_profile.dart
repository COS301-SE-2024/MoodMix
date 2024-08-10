import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import this for SVG support
import 'package:frontend/components/profile_timeline_node.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/navbar.dart';
import '../auth/auth_service.dart';

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
  bool isLoading = true;
  bool isFadeOut = false;

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
    final spotifyUserDetails = await SpotifyAuth.fetchUserDetails();
    if (spotifyUserDetails != null) {
      setState(() {
        _spotifyUsername = spotifyUserDetails['display_name'];
        _spotifyProfileImage = spotifyUserDetails['images'] != null && spotifyUserDetails['images'].isNotEmpty
            ? spotifyUserDetails['images'][1]['url']
            : '';
        _playlistNames = spotifyUserDetails['playlists'] != null
            ? List<String>.from(spotifyUserDetails['playlists'].map((playlist) => playlist['name']))
            : [];
      });
    }
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

  void _onOptionsPressed() {
    // Implement options button functionality here
    print('Options button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false, // Ensures no back button
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(20),
                child: SvgPicture.asset(
                  'assets/images/SimpleLogo.svg',
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Content of the page
          Visibility(
            visible: !isLoading,
            child: SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final parentWidth = constraints.maxWidth;
                  final avatarRadius = parentWidth / 5;
                  final avatarCenterX = avatarRadius * 0.25;

                  return Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: _spotifyProfileImage != null
                                    ? NetworkImage(_spotifyProfileImage!)
                                    : AssetImage('assets/images/images.jpeg') as ImageProvider,
                                backgroundColor: Colors.transparent,
                                radius: avatarRadius,
                              ),
                              SizedBox(width: 30),
                              Flexible(
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your Profile',
                                          style: TextStyle(
                                            fontSize: parentWidth * 0.09,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        Text(
                                          'Temp $_displayName',
                                          style: TextStyle(
                                            fontSize: parentWidth * 0.07,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        Text(
                                          '$_spotifyUsername',
                                          style: TextStyle(
                                            fontSize: parentWidth * 0.07,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                          ProfileTimelineNode(
                            title: "Test Playlist One",
                            mood: "Happy",
                            date: "12/02/2024",
                            alignOffset: avatarCenterX,
                            scale: parentWidth * 0.004,
                          ),
                          ProfileTimelineNode(
                            title: "Test Playlist Two",
                            mood: "Sad",
                            date: "12/02/2024",
                            alignOffset: avatarCenterX,
                            scale: parentWidth * 0.004,
                          ),
                          ProfileTimelineNode(
                            title: "Test Playlist Three",
                            mood: "Angry",
                            date: "12/02/2024",
                            alignOffset: avatarCenterX,
                            scale: parentWidth * 0.004,
                          ),
                          ProfileTimelineNode(
                            title: "Test Playlist Three",
                            mood: "Angry",
                            date: "12/02/2024",
                            alignOffset: avatarCenterX,
                            scale: parentWidth * 0.004,
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
