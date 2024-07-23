import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

import 'package:frontend/components/navbar.dart';
import 'package:frontend/components/playlist_ribon.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  XFile? pictureFile;

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      print('Cameras available: ${widget.cameras}');
      controller = CameraController(widget.cameras[0], ResolutionPreset.high);
      controller?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((error) {
        print('Camera initialization error: $error');
      });
    } else {
      print('No cameras available');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: screenWidth * 0.8,
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.tertiary,
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                AspectRatio(
                                  aspectRatio: controller!.value.aspectRatio,
                                  child: CameraPreview(controller!),
                                ),
                                if (pictureFile != null)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.file(
                                        File(pictureFile!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        pictureFile = await controller?.takePicture();
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(15.0),
                                        backgroundColor: Colors.black12,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 40.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                          alignment: Alignment.center,
                          child: PlaylistRibbon(
                            onTap: (playlistIcon) {
                              // Handle onTap action if needed
                              print('Tapped on playlist: ');
                            },
                            mood: 'Happy', // Replace with actual mood if applicable
                            songCount: 12,
                            playlistLink: '12123231',
                            playlistName: 'dsfsdfsdf',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
