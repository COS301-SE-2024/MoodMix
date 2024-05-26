// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAUr98foEKJ3Q-aS1EtNXRSGFPgZ9a3sjw',
    appId: '1:717450671046:web:14552a7b99111d6de9b8c7',
    messagingSenderId: '717450671046',
    projectId: 'moodmix-fiveguys',
    authDomain: 'moodmix-fiveguys.firebaseapp.com',
    storageBucket: 'moodmix-fiveguys.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTwN6uxmqdVA1ZxJjLeWOYC0CkOngyR5Q',
    appId: '1:717450671046:android:09e1f445054eaa55e9b8c7',
    messagingSenderId: '717450671046',
    projectId: 'moodmix-fiveguys',
    storageBucket: 'moodmix-fiveguys.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6tNZqcutSAVLuoP_MC6L7Wp1iOCWn068',
    appId: '1:717450671046:ios:e127f2558197f123e9b8c7',
    messagingSenderId: '717450671046',
    projectId: 'moodmix-fiveguys',
    storageBucket: 'moodmix-fiveguys.appspot.com',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6tNZqcutSAVLuoP_MC6L7Wp1iOCWn068',
    appId: '1:717450671046:ios:e127f2558197f123e9b8c7',
    messagingSenderId: '717450671046',
    projectId: 'moodmix-fiveguys',
    storageBucket: 'moodmix-fiveguys.appspot.com',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAUr98foEKJ3Q-aS1EtNXRSGFPgZ9a3sjw',
    appId: '1:717450671046:web:c069ab6578ff0ea1e9b8c7',
    messagingSenderId: '717450671046',
    projectId: 'moodmix-fiveguys',
    authDomain: 'moodmix-fiveguys.firebaseapp.com',
    storageBucket: 'moodmix-fiveguys.appspot.com',
  );
}
