import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:frontend/auth/auth_service.dart';

class LinkSpotify extends StatefulWidget {
  const LinkSpotify({Key? key}) : super(key: key);

  @override
  State<LinkSpotify> createState() => _LinkSpotifyState();
}

class _LinkSpotifyState extends State<LinkSpotify> {
  String backendUrl = '';

  @override
  void initState() {
    super.initState();
    _initializeBackendUrl();
    _checkCachedToken();
    SpotifyAuth.initialize(_onLoginSuccess);
  }

  Future<void> _checkCachedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('spotify_access_token');
    final int? storedTimestamp = prefs.getInt('token_timestamp');

    if (token != null && storedTimestamp != null) {
      final int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
      final int tokenLifetimeMillis = 24 * 60 * 60 * 1000; // 24 hours in milliseconds

      if (currentTimeMillis - storedTimestamp <= tokenLifetimeMillis) {
        // Token is still valid
        SpotifyAuth.setAccessToken(token);
        Navigator.pushReplacementNamed(context, '/camera');
      } else {
        print('Token expired');
        await _clearCache(); // Optionally clear expired token
      }
    } else {
      print('No cached token found or timestamp missing');
    }
  }

  Future<void> _clearCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('spotify_access_token');
    await prefs.remove('token_timestamp');
  }


  Future<void> _initializeBackendUrl() async {
    final NetworkInfo networkInfo = NetworkInfo();
    final String? ipAddress = await networkInfo.getWifiIP();
    if (ipAddress != null) {
      setState(() {
        backendUrl = 'http://$ipAddress:5002/login'; // Update with your backend URL
      });
    } else {
      print('Failed to get IP address');
    }
  }

  Future<void> _linkSpotify() async {
    try {
      await SpotifyAuth.authenticate(); // Retrieves access token
    } catch (e) {
      print('Error: $e');
    }
  }



  void _linkSpotify2() async { //this is the method for web, which we are not going to currently use
    if (backendUrl.isEmpty) {
      print('Backend URL is not initialized');
      return;
    }
    final Uri uri = Uri.parse(backendUrl);

    try {
      // Open the backend /login endpoint in the user's browser
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        print('Could not launch $backendUrl');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _onLoginSuccess(String accessToken) async {
    if (accessToken != null) {
      // Store the token and timestamp
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

      await prefs.setString('spotify_access_token', accessToken);
      await prefs.setInt('token_timestamp', currentTimeMillis);

      Navigator.pushReplacementNamed(context, '/camera');
    } else {
      print(accessToken);
      print('Authentication failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                        width: screenWidth,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                iconSize: 35,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/welcome');
                                  dispose();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/images/SimpleLogo.svg',
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: screenWidth * 0.75,
                              child: Text(
                                'Link your Spotify',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.065,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 35),
                            Container(
                              width: screenWidth * 0.75,
                              child: Text(
                                "Why do you need to link your Spotify?\n\nLinking your Spotify is necessary for the use of the MoodMix application. This application communicates directly with Spotify to create playlists, save playlists to your personal library, and more!",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 35),
                            Container(
                              width: screenWidth * 0.75,
                              child: FloatingActionButton.extended(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                onPressed: _linkSpotify,
                                icon: Image.asset(
                                  "assets/icons/Spotify_Full_Logo_RGB_Black.png",
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 200,
                                ),
                                label: Text(''),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
