import 'package:flutter/material.dart';
import 'package:frontend/pages/loading.dart';
import 'package:frontend/pages/log_in.dart';
import 'package:frontend/pages/sing_up.dart';
import 'package:frontend/pages/welcome.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/welcome',
  routes: {
    '/': (context) => const Loading(),
    '/welcome': (context) => const Welcome(),
    '/signup': (context) => const SingUp(),
    '/login': (context) => const LogIn(),
  }
));
