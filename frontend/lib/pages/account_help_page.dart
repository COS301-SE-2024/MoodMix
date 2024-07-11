import 'package:flutter/material.dart';

class AccountHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/help'); // Navigate back to /homepage
        },
      ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenSize.width,
              height: screenSize.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        SizedBox(height: screenSize.height * 0.05),
                         Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                            child: Text(
                              "How To Use Mood Mix",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: screenSize.width * 0.064,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.92,
                              ),
                            ),
                          ),
                        ),
                        _buildHelpSection(context, 'Link Spotify Account', [
                          '(navigate to Link page>Sign in>Spotify access)',
                        ]),
                        _buildHelpSection(context, 'Take a photo', [
                          '(navigate to Camera page>Take photo)',
                        ]),
                        _buildHelpSection(context, 'Accept Photo', [
                          '(Accept photo or retake)',
                        ]),
                        _buildHelpSection(context, 'Generate Playlist', [
                          '(click “generate playlist”>Wait for playlist to load)',
                        ]),
                        _buildHelpSection(context, 'Confirm Playlist', [
                          '(Confirm playlist or regenerate)',
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, String title, List<String> items) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/userprofile');
        
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
                  fontWeight: FontWeight.w600,
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
                      fontWeight: FontWeight.w300,
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
