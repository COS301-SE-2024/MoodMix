import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:frontend/components/expanded_playlist.dart';
// import 'package:frontend/components/playlist_details.dart';
// import 'package:frontend/components/playlist_ribon.dart';
import 'package:frontend/pages/account_help_page.dart';
import 'package:frontend/pages/camera_voice_help_page.dart';
import 'package:frontend/pages/help_page.dart';
import 'package:frontend/pages/playlist_help_page.dart';
import 'package:frontend/pages/settings.dart';
import 'package:frontend/pages/user_profile.dart';
import 'package:frontend/pages/link_spotify.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'auth/auth_service.dart';
import 'firebase_options.dart';
import 'package:frontend/pages/log_in.dart';
import 'package:frontend/pages/sing_up.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/pages/user_playlist.dart';
import 'package:frontend/pages/camera.dart';
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
      child: MyApp(),
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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Force navigation to the /camera page when back is pressed
        Navigator.pushNamedAndRemoveUntil(context, '/camera', (route) => false);
        return false; // Prevent default back action
      },
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Welcome(),
          '/signup': (context) => const SignUp(),
          '/login': (context) => LogIn(authService: AuthService(),),
          '/userprofile': (context) => const UserProfile(),
          '/linkspotify': (context) => const LinkSpotify(),
          '/userplaylist': (context) => const PlaylistPage(),
          '/camera': (context) => CameraPage(cameras: cameras), // Pass the actual cameras list here
          '/help': (context) => HelpPage(),
          '/accounthelp': (context) => AccountHelpPage(),
          '/playlisthelp': (context) => PlaylistHelpPage(),
          '/camerahelp': (context) => CameraVoiceHelpPage(),
          '/settings': (context) => SettingsPage(),
          '/audio': (context) => AudioPlayerPage(),
        },
        theme: Provider.of<ThemeProvider>(context).themeData,
      ),
    );
  }
}
