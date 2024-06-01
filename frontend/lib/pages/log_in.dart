import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _usernameOrEmailController.text.trim();
    final password = _passwordController.text.trim();

    // Call the login function in AuthService
    final result = await _authService.login(
      email: email,
      password: password,
    );

    if (result == 'Success') {
      // Navigate to the home screen if login is successful
      Navigator.pushNamed(context, '/home');
    } else {
      // Show error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Login failed')),
      );
    }
  }

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
                "Log In",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: screenWidth / 1.4,
                      child: TextField(
                        controller:
                            _usernameOrEmailController, // Attach the controller
                        decoration: InputDecoration(
                          hintText: 'Username or Email',
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(171, 255, 255, 255),
                          ),
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight / 25),
                    SizedBox(
                      width: screenWidth / 1.4,
                      child: TextField(
                        controller:
                            _passwordController, // Attach the controller
                        obscureText: true, // Obscure password input
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(171, 255, 255, 255),
                          ),
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Spacer(), // Add Spacer to push button to bottom
                    SizedBox(
                      height: 80,
                      width: screenWidth / 1.4,
                      child: OutlinedButton(
                        onPressed: _login, // Call the login function
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text.rich(
                          TextSpan(
                            text: "Don't have an account?\n",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: "Create Account",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  color: const Color.fromARGB(255, 255, 255,
                                      255), // Change the color of the clickable text
                                  decoration: TextDecoration
                                      .underline, // Add underline to indicate it's clickable
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                              ),
                              TextSpan(
                                  text: "\n\nTerms and Conditions",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                  )),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
