// Mocks generated by Mockito 5.4.4 from annotations
// in frontend/test/user_profile_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:firebase_auth/firebase_auth.dart' as _i6;
import 'package:frontend/auth/auth_service.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;

import 'spotify_auth_non_static.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [SpotifyAuthNonStatic].
///
/// See the documentation for Mockito's code generation for more information.
class MockSpotifyAuthNonStatic extends _i1.Mock
    implements _i2.SpotifyAuthNonStatic {
  MockSpotifyAuthNonStatic() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set currentUser(_i3.SpotifyUser? _currentUser) => super.noSuchMethod(
        Invocation.setter(
          #currentUser,
          _currentUser,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String get selectedGenres => (super.noSuchMethod(
        Invocation.getter(#selectedGenres),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#selectedGenres),
        ),
      ) as String);

  @override
  set selectedGenres(String? _selectedGenres) => super.noSuchMethod(
        Invocation.setter(
          #selectedGenres,
          _selectedGenres,
        ),
        returnValueForMissingStub: null,
      );

  @override
  List<String> get realtimeArtists => (super.noSuchMethod(
        Invocation.getter(#realtimeArtists),
        returnValue: <String>[],
      ) as List<String>);

  @override
  set realtimeArtists(List<String>? _realtimeArtists) => super.noSuchMethod(
        Invocation.setter(
          #realtimeArtists,
          _realtimeArtists,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<String?> authenticate() => (super.noSuchMethod(
        Invocation.method(
          #authenticate,
          [],
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);

  @override
  void initialize(dynamic Function(String)? onSuccessCallback) =>
      super.noSuchMethod(
        Invocation.method(
          #initialize,
          [onSuccessCallback],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setAccessToken(String? a) => super.noSuchMethod(
        Invocation.method(
          #setAccessToken,
          [a],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<Map<String, dynamic>?> fetchUserDetails() => (super.noSuchMethod(
        Invocation.method(
          #fetchUserDetails,
          [],
        ),
        returnValue: _i5.Future<Map<String, dynamic>?>.value(),
      ) as _i5.Future<Map<String, dynamic>?>);

  @override
  _i5.Future<List<Map<String, dynamic>>?> fetchUserPlaylists(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserPlaylists,
          [userId],
        ),
        returnValue: _i5.Future<List<Map<String, dynamic>>?>.value(),
      ) as _i5.Future<List<Map<String, dynamic>>?>);

  @override
  _i5.Future<Map<String, dynamic>?> fetchPlaylistTracks(String? playlistId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchPlaylistTracks,
          [playlistId],
        ),
        returnValue: _i5.Future<Map<String, dynamic>?>.value(),
      ) as _i5.Future<Map<String, dynamic>?>);

  @override
  _i5.Future<List<Map<String, dynamic>>?> fetchTrackAudioFeatures(
          List<String>? trackIds) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchTrackAudioFeatures,
          [trackIds],
        ),
        returnValue: _i5.Future<List<Map<String, dynamic>>?>.value(),
      ) as _i5.Future<List<Map<String, dynamic>>?>);

  @override
  _i5.Future<String> calculateAggregateMood(String? playlistId) =>
      (super.noSuchMethod(
        Invocation.method(
          #calculateAggregateMood,
          [playlistId],
        ),
        returnValue: _i5.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #calculateAggregateMood,
            [playlistId],
          ),
        )),
      ) as _i5.Future<String>);

  @override
  _i5.Future<Map<String, List<String>>> fetchUserTopArtistsAndTracks() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserTopArtistsAndTracks,
          [],
        ),
        returnValue: _i5.Future<Map<String, List<String>>>.value(
            <String, List<String>>{}),
      ) as _i5.Future<Map<String, List<String>>>);

  @override
  void addArtist(String? artist) => super.noSuchMethod(
        Invocation.method(
          #addArtist,
          [artist],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<List<String>> moodOfTrackIDs({
    required List<String>? tracks,
    required String? mood,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #moodOfTrackIDs,
          [],
          {
            #tracks: tracks,
            #mood: mood,
          },
        ),
        returnValue: _i5.Future<List<String>>.value(<String>[]),
      ) as _i5.Future<List<String>>);

  @override
  _i5.Future<List<String>> getSpotifyRecommendations({
    required Map<String, List<String>>? topArtistsAndTracks,
    required double? valence,
    required double? energy,
    required String? mood,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSpotifyRecommendations,
          [],
          {
            #topArtistsAndTracks: topArtistsAndTracks,
            #valence: valence,
            #energy: energy,
            #mood: mood,
          },
        ),
        returnValue: _i5.Future<List<String>>.value(<String>[]),
      ) as _i5.Future<List<String>>);

  @override
  void setSelectedGenres(List<String>? genres) => super.noSuchMethod(
        Invocation.method(
          #setSelectedGenres,
          [genres],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<List<String>> realTimeGetSpotifyRecommendations({
    required List<String>? moods,
    required Map<String, List<String>>? topArtistsTracksGenres,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #realTimeGetSpotifyRecommendations,
          [],
          {
            #moods: moods,
            #topArtistsTracksGenres: topArtistsTracksGenres,
          },
        ),
        returnValue: _i5.Future<List<String>>.value(<String>[]),
      ) as _i5.Future<List<String>>);

  @override
  double moodToValence(String? mood) => (super.noSuchMethod(
        Invocation.method(
          #moodToValence,
          [mood],
        ),
        returnValue: 0.0,
      ) as double);

  @override
  Map<String, double> songParameters(String? mood) => (super.noSuchMethod(
        Invocation.method(
          #songParameters,
          [mood],
        ),
        returnValue: <String, double>{},
      ) as Map<String, double>);

  @override
  _i5.Future<void> createAndPopulatePlaylistWithRecommendations(
    String? playlistName,
    String? mood,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createAndPopulatePlaylistWithRecommendations,
          [
            playlistName,
            mood,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> realTimeCreateAndPopulatePlaylistWithRecommendations(
    String? playlistName,
    List<String>? moods,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #realTimeCreateAndPopulatePlaylistWithRecommendations,
          [
            playlistName,
            moods,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> createAndPopulatePlaylist(
    String? playlistName,
    String? mood,
    List<String>? trackUris,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createAndPopulatePlaylist,
          [
            playlistName,
            mood,
            trackUris,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> addTracksToPlaylist(
    String? playlistId,
    List<String>? trackUris,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addTracksToPlaylist,
          [
            playlistId,
            trackUris,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i3.AuthService {
  MockAuthService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<String?> registration({
    required String? email,
    required String? password,
    required String? username,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #registration,
          [],
          {
            #email: email,
            #password: password,
            #username: username,
          },
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);

  @override
  _i5.Future<String?> login({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #login,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);

  @override
  _i5.Future<String?> sendPasswordResetEmail(String? email) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendPasswordResetEmail,
          [email],
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);

  @override
  _i5.Future<_i6.User?> getCurrentUser() => (super.noSuchMethod(
        Invocation.method(
          #getCurrentUser,
          [],
        ),
        returnValue: _i5.Future<_i6.User?>.value(),
      ) as _i5.Future<_i6.User?>);
}
