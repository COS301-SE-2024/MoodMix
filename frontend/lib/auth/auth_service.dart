import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '717450671046-s8e21c4eu14ebejnnc3varjpues2g2s2.apps.googleusercontent.com',
  );

  Future<Map<String, dynamic>?> getSpotifyUserDetails() async {
    final String endpoint =
        'http://localhost:5002/spotify-user'; // Replace with your backend endpoint
    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load user details');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getSpotifyPlaylists() async {
    final String endpoint =
        'http://localhost:5002/spotify-playlists'; // Replace with your backend endpoint

    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> playlists = jsonResponse['items'];
        List<Map<String, dynamic>> formattedPlaylists = playlists
            .map((playlist) => {
                  'id': playlist['id'],
                  'name': playlist['name'],
                  'description': playlist['description'],
                  'image': playlist['images'].isNotEmpty
                      ? playlist['images'][0]['url']
                      : null,
                  'owner': playlist['owner']['display_name'],
                  'tracks': playlist['tracks']['total'],
                  'public': playlist['public'],
                  'href': playlist['external_urls']['spotify'],
                })
            .toList();
        return formattedPlaylists;
      } else {
        print('Failed to load Spotify playlists: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

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


class SpotifyAuth {
  static const MethodChannel _channel = MethodChannel('spotify_auth');

  static Future<void> authenticate() async {
    try {
      await _channel.invokeMethod('authenticate');
    } on PlatformException catch (e) {
      print("Failed to authenticate: ${e.message}");
    }
  }
}