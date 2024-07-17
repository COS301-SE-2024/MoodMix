import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/components/profile_timeline_node.dart';
import 'package:frontend/pages/account_help_page.dart';
import 'package:frontend/pages/camera_voice_help_page.dart';
import 'package:frontend/pages/help_page.dart';
import 'package:frontend/pages/playlist_help_page.dart';
import 'package:frontend/pages/stub_homepage.dart';
import 'package:frontend/pages/user_profile.dart';
import 'package:frontend/pages/link_spotify.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:frontend/pages/loading.dart';
import 'package:frontend/pages/log_in.dart';
import 'package:frontend/pages/sing_up.dart';  // Fixed typo from 'sing_up' to 'sign_up'
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/pages/user_playlist.dart';
import 'package:frontend/pages/camera.dart';  // Changed import to match CameraPage class file name
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/pages/audio_player_page.dart';

List<CameraDescription> cameras = <CameraDescription>[];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "assets/.env");

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(cameras: cameras),
    ),
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
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/welcome',
      routes: {
        '/': (context) => const Loading(),
        '/welcome': (context) => const Welcome(),
        '/signup': (context) => const SignUp(),
        '/login': (context) => const LogIn(),
        '/userprofile': (context) => const UserProfile(),
        // '/linkspotify': (context) => const LinkSpotify(),
        '/homepage': (context) => const StubHomePage(),
        '/userplaylist': (context) => const PlaylistPage(),
        '/camera': (context) => CameraPage(cameras: cameras),  // Pass the cameras list here
        // '/audio': (context) => AudioPlayerPage(),
        '/help': (context) => HelpPage(),
        '/accounthelp': (context) => AccountHelpPage(),
        '/playlisthelp': (context) => PlaylistHelpPage(),
        '/camerahelp': (context) => CameraVoiceHelpPage(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
