import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart'; 
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatefulWidget{
  const CameraPage({Key? key}): super(key:key);

  @override
  State<CameraPage> createState() => _CameraPage();
}

class _CameraPage extends State<CameraPage>{

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.65,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, // Move color here
                borderRadius: BorderRadius.circular(20.0), // Set rounded edges
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        print("James Created a Button");
                      },
                      child: Icon(
                        Icons.camera_alt, // Camera icon
                        color: Colors.white, // Icon color
                        size: 40.0, // Icon size
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding: EdgeInsets.all(15.0), // Padding to make the button smaller
                        iconColor: Colors.blue, // Button color
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
      bottomNavigationBar: NavBar(
        // Replace bottomNavigationBar with your BottomNavbar component
        currentIndex: 1, // Set current index accordingly
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/userplaylist');
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
            case 4:
              Navigator.pushReplacementNamed(context, '/camera');
              break;
          }
        },
      ),
    );
  } 
}