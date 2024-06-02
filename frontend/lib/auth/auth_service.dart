import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '717450671046-s8e21c4eu14ebejnnc3varjpues2g2s2.apps.googleusercontent.com',
  );

  Future<String?> registration({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateProfile(displayName: username);
      await userCredential.user?.reload();

      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        return 'Success';
      } else {
        // User cancelled Google sign-in
        return 'Google sign-in cancelled.';
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<void> authenticateWithSpotify(BuildContext context) async {
    final url =
        'https://accounts.spotify.com/authorize?client_id=4a35390dc3c74e85abfd35698529a7f8&response_type=code&redirect_uri=http://localhost:5001/callback&scope=user-read-email';

    final result = await FlutterWebAuth.authenticate(
      url: url,
      callbackUrlScheme: 'myapp',
    );

    final code = Uri.parse(result).queryParameters['code'];

    if (code != null) {
      await _linkSpotifyAccountToFirebase(code);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Spotify account linked successfully!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to link Spotify account.'),
      ));
    }
  }

  Future<void> _linkSpotifyAccountToFirebase(String code) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final OAuthCredential credential = OAuthProvider('spotify.com').credential(
      accessToken: code,
    );
    await user?.linkWithCredential(credential);
  }
}
