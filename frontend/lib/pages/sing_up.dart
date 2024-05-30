import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
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
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
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
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
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
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(171, 255, 255, 255),
                          ),
                          fillColor: Colors.white,
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
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
                              fontFamily: 'test',
                              fontStyle: FontStyle.normal,
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
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: "Log In",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
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
