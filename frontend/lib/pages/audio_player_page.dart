import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../components/navbar.dart';

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({Key? key}) : super(key: key);

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  bool isPlaying = false; // Track play/pause state
  Map<String, dynamic>? _trackDetails;

  @override
  void initState() {
    super.initState();
    _initializeTrack();
  }

  Future<void> _initializeTrack() async {


    final trackDetails = await _getTrackDetails('4CeeEOM32jQcH3eN9Q2dG');
    if (trackDetails != null) {
      setState(() {
        _trackDetails = trackDetails;
      });
    }
  }

  Future<Map<String, dynamic>?> _getTrackDetails(String trackId) async {

    String? clientId = dotenv.env["SPOTIFY_CLIENT_ID"];
    try {
      final token = await SpotifyAuth.getAccessToken();
      print("Busy fetching song details");
      print(token);
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/tracks/74loibzxXRL875X20kenvk'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("response we got back is as follows: ");
      print(response);

      if (response.statusCode == 200) {
        print(response);
        return jsonDecode(response.body);
      } else {
        print(response);
        print('Failed to fetch track details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching track details: $e');
      return null;
    }
  }

  void _playSong() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:74loibzxXRL875X20kenvk');
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (isPlaying) {
        SpotifySdk.pause(); // Add this if you want to handle pause separately
        isPlaying = false;
      } else {
        _playSong();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                  width: screenWidth,
                  child: Stack(
                    children: [
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: screenWidth * 0.75,  // Adjust width as needed
                        height: screenWidth * 0.75, // Adjust height as needed
                        color: Colors.orange,
                        child: Center(
                          child: _trackDetails != null
                              ? Image.network(_trackDetails!['album']['images'][0]['url'])
                              : CircularProgressIndicator(),
                        ),
                      ),
                      SizedBox(height: 20), // Space between container and text
                      Text(
                        _trackDetails != null ? _trackDetails!['name'] : 'Loading...',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _trackDetails != null
                            ? _trackDetails!['artists'][0]['name']
                            : 'Loading...',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 20), // Space between text and progress bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            // Progress bar
                            Slider(
                              value: 0.0, // Example value
                              onChanged: (value) {
                                // Handle progress bar change
                              },
                              activeColor: Theme.of(context).colorScheme.secondary,
                              inactiveColor: Colors.grey,
                            ),
                            SizedBox(height: 20), // Space between progress bar and buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.skip_previous),
                                  color: Theme.of(context).colorScheme.secondary,
                                  iconSize: 30,
                                  onPressed: () {
                                    // Handle previous button press
                                  },
                                ),
                                IconButton(
                                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                                  color: Theme.of(context).colorScheme.secondary,
                                  iconSize: 40,
                                  onPressed: _togglePlayPause,
                                ),
                                IconButton(
                                  icon: Icon(Icons.skip_next),
                                  color: Theme.of(context).colorScheme.secondary,
                                  iconSize: 30,
                                  onPressed: () {
                                    // Handle next button press
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
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
              Navigator.pushReplacementNamed(context, '/audio_player_page');
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
