import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/pages/account_help_page.dart';
import 'package:frontend/pages/help_page.dart';
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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/pages/audio_player_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    await dotenv.load(fileName: "../.env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    )
  );
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
        '/audio': (context) => AudioPlayerPage(),
        '/help': (context) => HelpPage(),
        '/accounthelp': (context) => AccountHelpPage(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
