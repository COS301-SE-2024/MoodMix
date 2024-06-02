import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'package:frontend/components/navbar.dart'; // Import your new bottom navbar component

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? _email = '';
  String? _displayName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService().getCurrentUser();
    if (user != null) {
      setState(() {
        _email = user.email;
        _displayName = user.displayName;
      });
    }
  }

  Future<void> _changeUsername(String newDisplayName) async {
    final user = await AuthService().getCurrentUser();
    if (user != null) {
      try {
        await user.updateDisplayName(newDisplayName);
        setState(() {
          _displayName = newDisplayName;
        });
        // Optionally, you can show a success message to the user here
      } catch (e) {
        // Handle error
        print("Failed to update username: $e");
        // Optionally, you can show an error message to the user here
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/images.jpeg'),
                  backgroundColor: Colors.transparent,
                  radius: screenHeight / 10,
                ),
              ),
              IntrinsicWidth(
                child: TextField(
                  onEditingComplete: () {},
                  decoration: InputDecoration(
                    hintText: '$_displayName',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    suffixIcon: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                child: Text(
                  '$_email',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
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
          }
        },
      ),
    );
  }
}
