import 'dart:convert';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/main.dart'; 
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class CameraPage extends StatefulWidget{
  const CameraPage({Key? key, required this.cameras}): super(key:key);

  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPage();
}

class _CameraPage extends State<CameraPage>{
  //Changed the type to late was CameraController controller?
  late CameraController controller;
  late XFile pictureFile;
  String bs64 = "";

    @override
  void initState() {
    super.initState();
    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[0], ResolutionPreset.high);
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
  void dispose(){
    controller?.dispose();
    super.dispose();
  } 

  // Future<String> convertImageToBase64(XFile image) async{
  //   final bytes = await File(image.path).readAsBytes();
  //   return base64Encode(bytes);
  // }

  @override
  Widget build(BuildContext context){
    //Commented the Edge Case for a Null Camera out because Late allows the initialisation of the controller at a later point
    // if (controller == null || !controller!.value.isInitialized) {
    //   return Scaffold(
    //   backgroundColor: Theme.of(context).colorScheme.primary,
    //   body: SafeArea(
    //     child: Align(
    //         alignment: Alignment.topCenter,
    //         child: Container(
    //           width: MediaQuery.of(context).size.width * 0.75,
    //           height: MediaQuery.of(context).size.height * 0.65,
    //           margin: EdgeInsets.only(top: 20),
    //           padding: EdgeInsets.all(20),
    //           decoration: BoxDecoration(
    //             color: Colors.grey,
    //             borderRadius: BorderRadius.circular(20.0), 
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.grey.withOpacity(0.5),
    //                 spreadRadius: 2,
    //                 blurRadius: 5,
    //                 offset: Offset(0, 3), 
    //               ),
    //             ],
    //           ),
    //           child: Stack(
    //             children: [
    //               Align(
    //                 alignment: Alignment.bottomCenter,
    //                 child: ElevatedButton(
    //                   onPressed: () async{
    //                     print("No Camera Avaliable");
    //                   },
    //                   style: ElevatedButton.styleFrom(
    //                     shape: CircleBorder(), 
    //                     padding: EdgeInsets.all(15.0), 
    //                     iconColor: Colors.blue, 
    //                   ),
    //                   child: Icon(
    //                     Icons.camera_alt, 
    //                     color: Colors.white, 
    //                     size: 40.0, 
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //     ),
    //   ),
    //   bottomNavigationBar: NavBar(
    //     // Replace bottomNavigationBar with your BottomNavbar component
    //     currentIndex: 1, // Set current index accordingly
    //     onTap: (index) {
    //       switch (index) {
    //         case 0:
    //           Navigator.pushReplacementNamed(context, '/userplaylist');
    //           break;
    //         case 1:
    //           Navigator.pushReplacementNamed(context, '/userprofile');
    //           break;
    //         case 2:
    //           Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
    //           break;
    //         case 3:
    //           Navigator.pushReplacementNamed(context, '/userplaylist');
    //           break;
    //         case 4:
    //           Navigator.pushReplacementNamed(context, '/camera');
    //           break;
    //       }
    //     },
    //   ),
    // );
    // }

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
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey, 
                borderRadius: BorderRadius.circular(20.0), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), 
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Expanded(child: CameraPreview(controller!)),
                  if(pictureFile != null)
                    Image.file(File(pictureFile!.path)),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () async{
                        pictureFile = await controller.takePicture();
                        //For Converting the Image to Base64
                        // bs64 = await convertImageToBase64(pictureFile);
                        setState(() {
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), 
                        padding: EdgeInsets.all(15.0), 
                        iconColor: Colors.blue, 
                      ),
                      child: Icon(
                        Icons.camera_alt, 
                        color: Colors.white,
                        size: 40.0, 
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
        currentIndex: 1, 
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