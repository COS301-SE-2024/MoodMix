import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/pages/stub_homepage.dart';
import 'package:frontend/pages/user_profile.dart';
import 'package:frontend/pages/link_spotify.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:frontend/pages/loading.dart';
import 'package:frontend/pages/log_in.dart';
import 'package:frontend/pages/sing_up.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/pages/user_playlist.dart';
import 'package:frontend/pages/camera.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    )
  );
}

Future<void> initializeCameras() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: ${e.code}\nError Message: ${e.description}');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/userplaylist',
      routes: {
        '/': (context) => const Loading(),
        '/welcome': (context) => const Welcome(),
        '/signup': (context) => const SignUp(),
        '/login': (context) => const LogIn(),
        '/userprofile': (context) => const UserProfile(),
        '/linkspotify': (context) => const LinkSpotify(),
        '/homepage': (context) => const StubHomePage(),
        '/userplaylist': (context) => const PlaylistPage(),
        '/camera':(context) => const CameraPage(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
