import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/navbar.dart';

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({Key? key}) : super(key: key);

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  bool isPlaying = false; // Track play/pause state

  @override
  void initState() {
    super.initState();
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                  width: screenWidth,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/images/SimpleLogo.svg',
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: screenWidth * 0.75,  // Adjust width as needed
                        height: screenWidth * 0.75, // Adjust height as needed
                        color: Colors.orange,
                        child: Center(
                          child: Image.asset("dkfjdf"), // Update with your asset path
                        ),
                      ),
                      SizedBox(height: 20), // Space between container and text
                      Text(
                        'Song',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Artist',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 20), // Space between text and progress bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            // Progress bar
                            Slider(
                              value: 0.0, // Example value
                              onChanged: (value) {
                                // Handle progress bar change
                              },
                              activeColor: Theme.of(context).colorScheme.secondary,
                              inactiveColor: Colors.grey,
                            ),
                            SizedBox(height: 20), // Space between progress bar and buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.skip_previous),
                                  color: Theme.of(context).colorScheme.secondary,
                                  iconSize: 30,
                                  onPressed: () {
                                    // Handle previous button press
                                  },
                                ),
                                IconButton(
                                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                                  color: Theme.of(context).colorScheme.secondary,
                                  iconSize: 40,
                                  onPressed: _togglePlayPause,
                                ),
                                IconButton(
                                  icon: Icon(Icons.skip_next),
                                  color: Theme.of(context).colorScheme.secondary,
                                  iconSize: 30,
                                  onPressed: () {
                                    // Handle next button press
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/camera');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/userprofile');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/audio');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/userplaylist');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/help');
              break;
          }
        },
      ),
    );
  }
}
