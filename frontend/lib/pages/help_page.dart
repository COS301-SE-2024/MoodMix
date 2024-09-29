import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text('Help Page'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/camera'); // Navigate back to /camera page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenSize.height,  // Make sure the container takes at least the screen's height
          ),
          child: Column(
            children: [
              Container(
                width: screenSize.width,
                // Remove height constraint to prevent overflow
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          SizedBox(height: screenSize.height * 0.05),
                          _buildHelpSection(context, 'Account', [
                            'How to Use Mood Mix',
                            'Account Linking',
                          ], '/accounthelp'),
                          _buildHelpSection(context, 'Playlists', [
                            'Playlist Generation',
                            'How to Add Playlists',
                          ], '/playlisthelp'),
                          _buildHelpSection(context, 'Camera & Voice', [
                            'Voice Recognition Settings',
                            'Camera Setup & Usage',
                          ], '/camerahelp'),
                          _buildHelpSection(context, 'FAQ', [
                            'Does it Save My Face?',
                            'Is my information secure?',
                          ], 'none'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, String title, List<String> items, String link) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, link);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
        child: Container(
          width: screenSize.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: screenSize.width * 0.064,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.92,
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              for (var item in items)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.005),
                  child: Text(
                    item,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: screenSize.width * 0.04,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
