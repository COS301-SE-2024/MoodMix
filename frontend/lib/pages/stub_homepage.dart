// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Text("Temporary Home Page"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar( // Replace bottomNavigationBar with your BottomNavbar component
        currentIndex: 1, // Set current index accordingly
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/homepage');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/userprofile');
              break;
            case 2:
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/userplaylist');
              break;
          }
        },
      ),
    );
  }
}
