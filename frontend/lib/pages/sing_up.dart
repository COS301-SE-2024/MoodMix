import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      // Show error message if passwords do not match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Call the registration function in AuthService
    final result = await _authService.registration(
      email: email,
      password: password,
      username: username,
    );

    if (result == 'Success') {
      // Link spotify navigation
      Navigator.pushNamed(context, '/linkspotify');
    } else {
      // Show error message if registration fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Registration failed')),
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
              padding: EdgeInsets.fromLTRB(0, 25, 0, 30),
              child: Text(
                "Create Your\nAccount",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: "Roboto",
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
                        cursorColor: Colors.white,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        controller: _usernameController, // Attach the controller
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(171, 255, 255, 255),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                          fillColor: Colors.white,

                          enabledBorder: UnderlineInputBorder(      
                            borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),   
                          ),  
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight / 25),
                    SizedBox(
                      width: screenWidth / 1.4,
                      child: TextField(
                        cursorColor: Colors.white,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        controller: _emailController, // Attach the controller
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(171, 255, 255, 255),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                          fillColor: Colors.white,

                          enabledBorder: UnderlineInputBorder(      
                            borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),   
                          ),  
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight / 25),
                    SizedBox(
                      width: screenWidth / 1.4,
                      child: TextField(
                        cursorColor: Colors.white,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        controller: _passwordController, // Attach the controller
                        obscureText: true, // Obscure password input
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(171, 255, 255, 255),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                          fillColor: Colors.white,

                          enabledBorder: UnderlineInputBorder(      
                            borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),   
                          ),  
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight / 25),
                    SizedBox(
                      width: screenWidth / 1.4,
                      child: TextField(
                        cursorColor: Colors.white,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        controller: _confirmPasswordController, // Attach the controller
                        obscureText: true, // Obscure password input
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(171, 255, 255, 255),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                          fillColor: Colors.white,

                          enabledBorder: UnderlineInputBorder(      
                            borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),   
                          ),  
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          ), 
                        ),
                      ),
                    ),
                    Spacer(), // Add Spacer to push button to bottom
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: SizedBox(
                        height: 80,
                        width: screenWidth / 1.4,
                        child: OutlinedButton(
                          onPressed: _createAccount, // Call the function
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Create',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                        child: Text.rich(
                          TextSpan(
                            text: "Already have an account?\n",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: "Log In",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                              ),
                              TextSpan(
                                text: "\n\nTerms and Conditions",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                )
                              ),
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
