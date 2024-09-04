import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/auth/auth_service.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkCachedData();
  }

  Future<void> _checkCachedData() async {
    // Simulate a loading delay (e.g., to fetch user data)
    await Future.delayed(Duration(seconds: 2));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    if (email != null && password != null) {
      // Try to authenticate using cached credentials
      final authResult = await AuthService().login(email: email, password: password);
      if (authResult == 'Success') {
        // Navigate to login or home screen after successful login
        Navigator.pushReplacementNamed(context, '/linkspotify');
      } else {
        // Continue to show Welcome screen if login fails
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // No cached credentials, show Welcome screen
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Show loading screen if still checking cached data
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      );
    }

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
                      Expanded(
                        flex: 1, // 1 part
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: SvgPicture.asset(
                            'assets/images/SimpleLogo.svg',
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5, // 5 parts
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: screenWidth / 7),
                          alignment: Alignment.center,
                          child: Text(
                            'Match the mood.',
                            style: TextStyle(
                              fontSize: screenWidth * 0.15,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3, // 3 parts
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth * 0.8,
                              child: FloatingActionButton.extended(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                onPressed: () async {
                                  String? signInResult =
                                  await AuthService().signInWithGoogle();
                                  if (signInResult == 'Success') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Sign-in successful!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Sign-in failed: $signInResult'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                icon: Image.asset(
                                  "assets/icons/GoogleLogo.png",
                                  width: 30,
                                ),
                                label: Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: screenWidth * 0.8,
                              child: FloatingActionButton.extended(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                label: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: screenWidth * 0.8,
                              child: FloatingActionButton.extended(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                label: Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1, // 1 part
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                            child: Text(
                              "Terms and Conditions",
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.secondary,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
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
