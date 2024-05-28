// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              
              SizedBox(height: screenHeight / 10),
              SizedBox(
                width: screenWidth / 1.4,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(color: const Color.fromARGB(171, 255, 255, 255)),
                    fillColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: screenHeight / 20),
              SizedBox(
                width: screenWidth / 1.4,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: const Color.fromARGB(171, 255, 255, 255)),
                    fillColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: screenHeight / 5),
              SizedBox(
                height: 80,
                width: screenWidth / 1.4,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'test',
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              
            ],
          )
          
        ),
      )
    );
  }
}
