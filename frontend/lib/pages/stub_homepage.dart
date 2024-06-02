// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class StubHomePage extends StatefulWidget {
  const StubHomePage({Key? key}) : super(key: key);

  @override
  State<StubHomePage> createState() => _StubHomePageState();
}

class _StubHomePageState extends State<StubHomePage> {
  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Image(
                  image: AssetImage('assets/images/MM-On Dark.png'),
                  width: screenWidth / 1.1,
                ),
              ),
              Text("Temporary Home Page"),
            ],
          ),
        ),
      ),
    );
  }
}