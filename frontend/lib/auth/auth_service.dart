import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/pages/link_spotify.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '717450671046-s8e21c4eu14ebejnnc3varjpues2g2s2.apps.googleusercontent.com',
  );

  Future<Map<String, dynamic>?> getSpotifyUserDetails() async {
    final String endpoint =
        'https://api.spotify.com/v1/me'; // Replace with your backend endpoint
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
  static String? _accessToken; // Static variable to hold the access token
  static Function(String)? _onSuccessCallback; // Callback function


  static Future<String?> authenticate() async {
    try {
      final String? accessToken = await _channel.invokeMethod(
          'authenticate'); // Calls native method
      return accessToken;
    } on PlatformException catch (e) {
      print("Failed to authenticate: ${e.message}");
      return null;
    }
  }

  // Initialize the service and set the method call handler
  static void initialize(Function(String) onSuccessCallback) {
    _onSuccessCallback = onSuccessCallback;
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  // Method to handle method calls from native code
  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onSuccess':
        String accessToken = call.arguments;
        _handleSuccess(accessToken);
        break;
      case 'onError':
        String error = call.arguments;
        _handleError(error);
        break;
      default:
        throw MissingPluginException('Not implemented: ${call.method}');
    }
  }

  static void _handleSuccess(String accessToken) {
    // Handle the access token (e.g., save it, use it for API calls, etc.)
    print('Login was a success and flutter has the recieved the token:');
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    print('Access Token: $accessToken');
    _accessToken = accessToken;
    if (_onSuccessCallback != null) {
      _onSuccessCallback!(accessToken); // Call the success callback
    }
  }

  static void _handleError(String error) {
    // Handle the error (e.g., show an error message to the user)
    print('Error: $error');
  }

  static String? getAccessToken() {
    return _accessToken;
  }

  static Future<Map<String, dynamic>?> fetchUserDetails() async {
    if (_accessToken == null) {
      print('Access token is not available');
      return null;
    }

    final String endpoint = 'https://api.spotify.com/v1/me';
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      if (response.statusCode == 200) {
        final userDetails = jsonDecode(response.body);
        print('User details fetched and stored:');
        print(userDetails);
        return userDetails;
      } else {
        print('Failed to fetch user details: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<List<dynamic>?> fetchUserPlaylists() async {
    if (_accessToken == null) {
      print('Access token is not available');
      return null;
    }

    final String endpoint = 'https://api.spotify.com/v1/me/playlists';
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      if (response.statusCode == 200) {
        final playlistDetails = jsonDecode(response.body);
        print('User playlists fetched and stored:');
        print(playlistDetails); // Debug print the entire response
        return playlistDetails['items'];
      } else {
        print('Failed to fetch user playlists: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchPlaylistTracks(
      String playlistId) async {
    if (_accessToken == null) {
      print('Access token is not available');
      return null;
    }

    final String endpoint = 'https://api.spotify.com/v1/playlists/$playlistId/tracks';
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      if (response.statusCode == 200) {
        final playlistData = jsonDecode(response.body);
        print('Playlist tracks fetched:');
        print(playlistData);
        return playlistData;
      } else {
        print('Failed to fetch playlist tracks: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchTrackAudioFeatures(
      List<String> trackIds) async {
    if (_accessToken == null) {
      print('Access token is not available');
      return null;
    }

    final String ids = trackIds.join(',');
    final String endpoint = 'https://api.spotify.com/v1/audio-features?ids=$ids';
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      if (response.statusCode == 200) {
        final audioFeatures = jsonDecode(response.body);
        print('Audio features fetched:');
        print(audioFeatures);
        return List<Map<String, dynamic>>.from(audioFeatures['audio_features']);
      } else {
        print('Failed to fetch audio features: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<String> calculateAggregateMood(String playlistId) async {
    final playlistTracks = await fetchPlaylistTracks(playlistId);
    if (playlistTracks == null || playlistTracks['items'] == null) {
      return 'Neutral';
    }

    final trackIds = (playlistTracks['items'] as List).map((
        item) => item['track']['id'] as String).toList();
    final audioFeatures = await fetchTrackAudioFeatures(trackIds);
    if (audioFeatures == null || audioFeatures.isEmpty) {
      return 'Neutral';
    }

    double avgValence = audioFeatures.map((
        feature) => feature['valence'] as double).reduce((a, b) => a + b) /
        audioFeatures.length;
    double avgEnergy = audioFeatures.map((
        feature) => feature['energy'] as double).reduce((a, b) => a + b) /
        audioFeatures.length;
    double avgDanceability = audioFeatures.map((
        feature) => feature['danceability'] as double).reduce((a, b) => a + b) /
        audioFeatures.length;
    double avgAcousticness = audioFeatures.map((
        feature) => feature['acousticness'] as double).reduce((a, b) => a + b) /
        audioFeatures.length;

    // Define stricter thresholds for moods
    const double happyValenceThreshold = 0.6;
    const double angryValenceThreshold = 0.3;
    const double sadValenceThreshold = 0.2;
    const double surprisedValenceThreshold = 0.8;

    const double highThreshold = 0.5;
    const double lowThreshold = 0.5;
    const double veryLowThreshold = 0.2;

    // Determine mood based on average values
    if (avgValence > happyValenceThreshold && avgEnergy > highThreshold &&
        avgDanceability > highThreshold && avgAcousticness < lowThreshold) {
      return 'Happy';
    } else
    if (avgValence < angryValenceThreshold && avgEnergy > highThreshold &&
        avgDanceability > highThreshold && avgAcousticness < lowThreshold) {
      return 'Angry';
    } else if (avgValence < sadValenceThreshold && avgEnergy < lowThreshold &&
        avgDanceability < lowThreshold && avgAcousticness > highThreshold) {
      return 'Sad';
    } else
    if (avgValence > surprisedValenceThreshold && avgEnergy > highThreshold &&
        avgDanceability > highThreshold && avgAcousticness < lowThreshold) {
      return 'Surprised';
    } else {
      // Check for neutral only if the playlist is perfectly balanced
      bool isPerfectlyBalanced =
          (avgValence > (sadValenceThreshold - 0.00005) &&
              avgValence < (happyValenceThreshold + 0.00005)) &&
              (avgEnergy > (lowThreshold - 0.00005) &&
                  avgEnergy < (highThreshold + 0.00005)) &&
              (avgDanceability > (lowThreshold - 0.00005) &&
                  avgDanceability < (highThreshold + 0.00005)) &&
              (avgAcousticness > (veryLowThreshold - 0.00005) &&
                  avgAcousticness < (highThreshold + 0.00005));


      if (isPerfectlyBalanced) {
        return 'Neutral';
      } else {
        // Classify based on closest matching mood if not perfectly balanced
        return _classifyMood(
            avgValence, avgEnergy, avgDanceability, avgAcousticness);
      }
    }
  }

// Helper function to classify based on closest mood
  static String _classifyMood(double valence, double energy, double danceability,
      double acousticness) {
    if (valence > 0.7 && energy > 0.7 && danceability > 0.7 &&
        acousticness < 0.5) {
      return 'Happy';
    } else if (valence < 0.3 && energy > 0.7 && danceability > 0.7 &&
        acousticness < 0.5) {
      return 'Angry';
    } else if (valence < 0.3 && energy < 0.3 && danceability < 0.3 &&
        acousticness > 0.7) {
      return 'Sad';
    } else if (valence > 0.8 && energy > 0.8 && danceability > 0.8 &&
        acousticness < 0.5) {
      return 'Surprised';
    } else if (valence > 0.5 && energy > 0.5 && danceability < 0.5 &&
        acousticness < 0.5) {
      return 'Angry'; // Example additional mood
    } else if (valence < 0.5 && energy > 0.5 && danceability < 0.5 &&
        acousticness < 0.5) {
      return 'Angry'; // Example additional mood
    } else if (valence < 0.5 && energy < 0.5 && danceability > 0.5 &&
        acousticness < 0.5) {
      return 'Sad'; // Example additional mood
    } else if (valence > 0.5 && energy < 0.5 && danceability < 0.5 &&
        acousticness < 0.5) {
      return 'Sad'; // Example additional mood
    } else {
      return 'Sad'; // For any cases not covered by the above conditions
    }
  }
}