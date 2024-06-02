import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/pages/user_profile.dart';
import 'firebase_options.dart';
import 'package:frontend/pages/loading.dart';
import 'package:frontend/pages/log_in.dart';
import 'package:frontend/pages/sing_up.dart';
import 'package:frontend/pages/welcome.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/userprofile',
      routes: {
        '/': (context) => const Loading(),
        '/welcome': (context) => const Welcome(),
        '/signup': (context) => const SignUp(),
        '/login': (context) => const LogIn(),
        '/userprofile': (context) => const UserProfile(),
      },
    );
  }
}




