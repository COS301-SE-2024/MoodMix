import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:js' as js;
import 'package:url_launcher/url_launcher.dart';

class LinkSpotify extends StatefulWidget {
  const LinkSpotify({Key? key}) : super(key: key);

  @override
  State<LinkSpotify> createState() => _LinkSpotifyState();
}

class _LinkSpotifyState extends State<LinkSpotify> {

  void _linkSpotify() async {
    //call backend to get the authorization URL
    const String backendUrl = 'http://localhost:5002/login'; // Replace with your backend URL
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
  

  @override
  void initState() {
    super.initState();
    handleCallback();
  }

  void handleCallback() {
    final Uri uri = Uri.parse(js.context['window'].location.href);
    final String? code = uri.queryParameters['code'];
    final String? error = uri.queryParameters['error'];
    if (code != null) {
      print('Authorization code: $code');
    } else if (error != null) {
      print('Authentication error: $error');
    } else {
      print('Unexpected callback');
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
                                "Why do you need to link your Spotify?\n\nLinking your spotify is necicary for the use of the MoodMix aplication. This aplication communicates directly with Spotify to create playlists, save playlists to your personal library and more!",
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