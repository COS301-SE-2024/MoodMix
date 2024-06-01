import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class LinkSpotify extends StatefulWidget {
  const LinkSpotify({Key? key}) : super(key: key);

  @override
  State<LinkSpotify> createState() => _LinkSpotifyState();
}

class _LinkSpotifyState extends State<LinkSpotify> {
  // final AuthService _authService = AuthService();
  // final TextEditingController _usernameOrEmailController =
  //     TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  // @override
  // void dispose() {
  //   _usernameOrEmailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  // void _LinkSpotify() async {
  //   final email = _usernameOrEmailController.text.trim();
  //   final password = _passwordController.text.trim();

  //   final result = await _authService.LinkSpotify(
  //     email: email,
  //     password: password,
  //   );

  //   if (result == 'Success') {
  //     Navigator.pushNamed(context, '/home');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('LinkSpotify successful')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(result ?? 'LinkSpotify failed')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 25, 0, 60),
              child: Text(
                "Link Your\nSpotify",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: screenWidth / 1.4,
                    child: Text(
                      "Why link your Spotify?",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(171, 255, 255, 255),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenHeight / 25),
                  SizedBox(
                    width: screenWidth / 1.4,
                    child: Text(
                      "This aplication offers meany features that are reliant on the link between this application and your Spotify account.",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(171, 255, 255, 255),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(), // Add Spacer to push button to bottom
                  SizedBox(
                    height: 80,
                    width: screenWidth / 1.4,
                    child: OutlinedButton(
                      onPressed: () {}, // Call the LinkSpotify function
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image(
                          image: AssetImage("assets/images/Spotify_Full_Logo_RGB_White.png"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child:Text(
                        "\n\nTerms and Conditions",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
