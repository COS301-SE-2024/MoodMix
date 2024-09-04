
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/pages/link_spotify.dart';
import 'dart:math';
import '/database/database.dart';
import 'package:intl/intl.dart';



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



class SpotifyUser {
  final String id;
  final String displayName;
  final String email;
  final String country;
  final String profileImageUrl;

  SpotifyUser({
    required this.id,
    required this.displayName,
    required this.email,
    required this.country,
    required this.profileImageUrl,
  });

  factory SpotifyUser.fromJson(Map<String, dynamic> json) {
    return SpotifyUser(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      email: json['email'] as String,
      country: json['country'] as String,
      profileImageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url'] as String
          : '', // Handle case where there are no images
    );
  }
}

class SpotifyAuth {
  static const MethodChannel _channel = MethodChannel('spotify_auth');
  static String? _accessToken; // Static variable to hold the access token
  static String? _refereshToken;
  static Function(String?,String?)? _onSuccessCallback; // Callback function
  static SpotifyUser? currentUser;


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
  static void initialize(Function(String?,String?) onSuccessCallback) {
    _onSuccessCallback = onSuccessCallback;
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  // Method to handle method calls from native code
  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onSuccess':
        Map<String, String> tokens = Map<String, String>.from(call.arguments);
        String? accessToken = tokens['accessToken'];
        String? refreshToken = tokens['refreshToken'];
        _handleSuccess(accessToken,refreshToken);
        break;
      case 'onError':
        String error = call.arguments;
        _handleError(error);
        break;
      default:
        throw MissingPluginException('Not implemented: ${call.method}');
    }
  }

  static void _handleSuccess(String? accessToken, String? refreshToken) {
    // Handle the access token (e.g., save it, use it for API calls, etc.)
    print('Login was a success and flutter has the recieved the token:');
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    print('Access Token: $accessToken');
    _accessToken = accessToken;
    _refereshToken = refreshToken;
    if (_onSuccessCallback != null) {
      _onSuccessCallback!(accessToken,refreshToken); // Call the success callback
    }
  }

  static void _handleError(String error) {
    // Handle the error (e.g., show an error message to the user)
    print('Error: $error');
  }

  static String? getAccessToken() {
    return _accessToken;
  }

  static void setAccessToken(String a) {
    _accessToken = a;
  }

  static String? getUserId(){

    if (currentUser == null) {
      return "User not found";
    }else{
      return currentUser?.id;
    }
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
        final userdetails = jsonDecode(response.body);
        print('User details fetched and stored:');
        print(userdetails);


        //this will store everything into an object for later use so that we can fetch the ID.
        currentUser = SpotifyUser.fromJson(userdetails);


        return userdetails;
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

  static Future<List<Map<String, dynamic>>?> fetchUserPlaylists(String? userId) async {
    if (_accessToken == null) {
      print('Access token is not available');
      return null;
    }

    // Fetch playlists from the local database
    List<Map<String, dynamic>> localPlaylists = await DatabaseHelper.getPlaylistsByUserId(userId);
    final List<String> localPlaylistIds = localPlaylists.map((playlist) => playlist['playlistId'] as String).toList();

    final String endpoint = 'https://api.spotify.com/v1/me/playlists';
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        final playlistDetails = jsonDecode(response.body);
        final List<dynamic> fetchedPlaylists = playlistDetails['items'];
        final List<Map<String, dynamic>> matchingPlaylists = [];

        // Loop through fetched playlists and compare with local database
        for (var playlist in fetchedPlaylists) {
          final String playlistId = playlist['id'];

          // Check if the fetched playlist ID matches any in the local database
          if (localPlaylistIds.contains(playlistId)) {
            // Find the corresponding local playlist entry
            final matchingLocalPlaylist = localPlaylists.firstWhere(
                  (localPlaylist) => localPlaylist['playlistId'] == playlistId,
            );

            // Add the mood from the local database to the playlist object
            playlist['mood'] = matchingLocalPlaylist['mood'];
            playlist['dateCreated'] = matchingLocalPlaylist['dateCreated'];
            matchingPlaylists.add(playlist);
          }
        }
        print("matching playlists are as follows:");
        print(matchingPlaylists);
        return matchingPlaylists;
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
        //print(playlistData);
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
        //print(audioFeatures);
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


  static Future<Map<String, List<String>>> fetchUserTopArtistsAndTracks() async {
    if (_accessToken == null) {
      print('Access token is not available');
      return {};
    }

    final String topArtistsEndpoint = 'https://api.spotify.com/v1/me/top/artists';

    try {
      final topArtistsResponse = await http.get(
        Uri.parse(topArtistsEndpoint),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (topArtistsResponse.statusCode == 200) {
        // Parse the top artists
        final Map<String, dynamic> artistsData = jsonDecode(topArtistsResponse.body);
        final List<dynamic> artists = artistsData['items'];

        // Select a random artist
        final Random random = Random();
        final int randomIndex = random.nextInt(artists.length);
        final Map<String, dynamic> randomArtist = artists[randomIndex];

        // Extract the artist's genres
        final List<String> genres = List<String>.from(randomArtist['genres']);

        // Fetch the artist's top tracks
        final String artistId = randomArtist['id'];
        print("Artist we will be choosing:");
        print(randomArtist['name']);
        final String topTracksEndpoint = 'https://api.spotify.com/v1/artists/$artistId/top-tracks?market=US';

        final topTracksResponse = await http.get(
          Uri.parse(topTracksEndpoint),
          headers: {'Authorization': 'Bearer $_accessToken'},
        );

        if (topTracksResponse.statusCode == 200) {
          // Parse the top tracks
          final Map<String, dynamic> tracksData = jsonDecode(topTracksResponse.body);
          final List<String> trackIds = [];
          for (var track in tracksData['tracks']) {
            trackIds.add(track['id']);
          }

          // Return the combined object
          return {
            'artistId': [artistId], // Wrapping artistId in a List to maintain consistency
            'genres': genres,
            'topTracks': trackIds,
          };
        } else {
          print('Failed to fetch top tracks for artist');
          return {};
        }
      } else {
        print('Failed to fetch top artists');
        return {};
      }
    } catch (e) {
      print('Error occurred: $e');
      return {};
    }
  }

  // Function to generate recommendations
  static Future<List<String>> getSpotifyRecommendations({
    required Map<String, List<String>> topArtistsAndTracks,
    required double valence,
  }) async {
    if (_accessToken == null) {
      print('Access token is not available');
      return [];
    }

    final String recommendationsEndpoint = 'https://api.spotify.com/v1/recommendations';

    // Prepare seed artists, tracks, and genres
    final List<String> seedArtists = topArtistsAndTracks['artistId'] ?? [];
    final List<String> seedTracks = topArtistsAndTracks['topTracks'] ?? [];
    final List<String> genres = topArtistsAndTracks['genres'] ?? [];

    if (seedArtists.isEmpty || genres.isEmpty || seedTracks.isEmpty) {
      print('Insufficient data to fetch recommendations');
      return [];
    }

    // Shuffle and select necessary items
    genres.shuffle();
    seedTracks.shuffle();

    // Take only 1 artist, 2 genres, and 2 tracks
    final List<String> seedArtistsLimited = seedArtists.take(1).toList();
    final List<String> seedGenresLimited = genres.take(2).toList();
    final List<String> seedTracksLimited = seedTracks.take(2).toList();

    // Construct the query parameters
    final Map<String, String> queryParams = {
      'limit': '100',
      'seed_artists': seedArtistsLimited.first,  // We only have one artist
      'seed_genres': seedGenresLimited.join(','),
      'seed_tracks': seedTracksLimited.join(','),
      'target_valence': valence.toString(),
    };

    print("Query parameters for fetching recommendations:");
    print(queryParams);

    final Uri uri = Uri.parse(recommendationsEndpoint).replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> recommendationsData = jsonDecode(response.body);
        final List<String> recommendedTrackIds = [];

        for (var track in recommendationsData['tracks']) {
          recommendedTrackIds.add(track['id']);
        }

        return recommendedTrackIds;
      } else {
        print(response.reasonPhrase);
        print('Failed to fetch recommendations');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }


  // Convert mood to a valence value
  static double moodToValence(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return 0.8;
      case 'sad':
        return 0.2;
      case 'angry':
        return 1.0;
      case 'neutral':
        return 0.5;


      default:
        return 0.5; // Neutral
    }
  }

  // Function to create and populate playlist with recommendations
  static Future<void> createAndPopulatePlaylistWithRecommendations(
      String playlistName,
      String mood
      ) async {
    if (_accessToken == null) {
      print('Access token is not available');
      return;
    }

    // Fetch top artists and tracks for seeds
    //final seeds = await fetchUserTopArtistsAndTracks();

    // if (seeds.isEmpty) {
    //   print('No seeds available for recommendations');
    //   return;
    // }

    // Generate recommendations based on mood
    Map<String, List<String>> topArtistsAndTracks = await fetchUserTopArtistsAndTracks();
    double valenceInput = moodToValence(mood);

    List<String> recommendedTracks = await getSpotifyRecommendations(
      topArtistsAndTracks: topArtistsAndTracks,
      valence: valenceInput,
    );


    // Create and populate the playlist
    await createAndPopulatePlaylist(playlistName, mood, recommendedTracks);
  }

  // Function to create and populate playlist
  static Future<void> createAndPopulatePlaylist(
      String playlistName,
      String mood,
      List<String> trackUris
      ) async {
    if (_accessToken == null) {
      print('Access token is not available');
      return;
    }

    if (currentUser == null) {
      print('User details not available');
      return;
    }

    final String userId = currentUser!.id;
    final String createPlaylistEndpoint = 'https://api.spotify.com/v1/users/$userId/playlists';
    final String userName = currentUser!.displayName;
    final Map<String, dynamic> requestBody = {
      'name': '$userName - $mood',
      'description': 'a $mood made and curated by MoodMix',
      'public': true,
    };

    try {
      final createPlaylistResponse = await http.post(
        Uri.parse(createPlaylistEndpoint),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (createPlaylistResponse.statusCode == 201) {
        print('Playlist created successfully');
        final Map<String, dynamic> playlistDetails = jsonDecode(createPlaylistResponse.body);
        final String playlistId = playlistDetails['id'];

        String now() {
          return DateFormat('yyyy-MM-dd').format(DateTime.now());
        }

        Map<String, dynamic> playlistData = {
          'playlistId': playlistId,
          'mood': mood,
          'userId': userId,
          'dateCreated': now(),
        };
        await instance.insertPlaylist(playlistData);




        await addTracksToPlaylist(playlistId, trackUris);
      } else {
        print('Failed to create playlist: ${createPlaylistResponse.statusCode}');
        print('Response body: ${createPlaylistResponse.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Function to add tracks to a playlist
  static Future<void> addTracksToPlaylist(String playlistId, List<String> trackUris) async {
    if (_accessToken == null) {
      print('Access token is not available');
      return;
    }

    final String addTracksEndpoint = 'https://api.spotify.com/v1/playlists/$playlistId/tracks';

    List<String> finalTrackIds = trackUris.map((id) => 'spotify:track:$id').toList();

    final Map<String, dynamic> requestBody = {
      'uris': finalTrackIds,
    };

    try {
      final addTracksResponse = await http.post(
        Uri.parse(addTracksEndpoint),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (addTracksResponse.statusCode == 201 || addTracksResponse.statusCode == 200) {
        print('Tracks added successfully to playlist');
      } else {
        print('Failed to add tracks: ${addTracksResponse.statusCode}');
        print('Response body: ${addTracksResponse.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}




