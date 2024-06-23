import 'package:flutter/material.dart';

class PlaylistHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Playlists'),
        backgroundColor: Color.fromARGB(255, 15, 15, 15),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/camera'); // Navigate back to /homepage
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
              decoration: BoxDecoration(color: Color(0xFF1D1C1C)),
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
                              "Playlist Generation",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenSize.width * 0.064,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.92,
                              ),
                            ),
                          ),
                        ),
                        _buildHelpSection(context, 'Take Photo', [
                          '(navigate to Camera Page>Take photo)',
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
                        _buildHelpSection(context, 'Add playlist to spotify', [
                          '(click “add to spotify”> confirm on spotify)',
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
                  color: Colors.white,
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
                      color: Colors.white,
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
