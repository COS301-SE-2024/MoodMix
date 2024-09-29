import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/pages/user_profile.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'model/auth_service_test.mocks.dart';
import 'spotify_auth_non_static.dart';
import 'package:provider/provider.dart'; // Assuming you use Provider for AuthService

import 'user_profile_test.mocks.dart'; // Generated mock class for SpotifyAuth

@GenerateMocks([SpotifyAuthNonStatic, AuthService])
void main() {
  late MockAuthService mockAuthService;
  late MockSpotifyAuthNonStatic mockSpotifyAuth;

  setUp(() {
    mockAuthService = MockAuthService();
    mockSpotifyAuth = MockSpotifyAuthNonStatic();
  });

  group('User Profile Tests', () {
    test('should authenticate user using SpotifyAuthNonStatic', () async {
      // Arrange
      when(mockSpotifyAuth.authenticate()).thenAnswer((_) async => 'user_token');

      // Act
      final token = await mockSpotifyAuth.authenticate();

      // Assert
      expect(token, equals('user_token'));
      verify(mockSpotifyAuth.authenticate()).called(1);
    });

    test('should fetch Spotify user playlists', () async {
      // Arrange
      when(mockSpotifyAuth.fetchUserPlaylists('user123'))
          .thenAnswer((_) async => [
        {'id': 'playlist1', 'name': 'My Playlist'},
        {'id': 'playlist2', 'name': 'Another Playlist'},
      ]);

      // Act
      final playlists = await mockSpotifyAuth.fetchUserPlaylists('user123');

      // Assert
      expect(playlists?.length, 2);
      expect(playlists?[0]['name'], 'My Playlist');
      verify(mockSpotifyAuth.fetchUserPlaylists('user123')).called(1);
    });

    test('should get current Firebase user from AuthService', () async {
      // Arrange
      final mockFirebaseUser = MockUser();
      when(mockAuthService.getCurrentUser()).thenAnswer((_) async => mockFirebaseUser);

      // Act
      final user = await mockAuthService.getCurrentUser();

      // Assert
      expect(user, isA<User>());
      verify(mockAuthService.getCurrentUser()).called(1);
    });

    test('should send password reset email', () async {
      // Arrange
      when(mockAuthService.sendPasswordResetEmail('test@example.com'))
          .thenAnswer((_) async => 'email_sent');

      // Act
      final result = await mockAuthService.sendPasswordResetEmail('test@example.com');

      // Assert
      expect(result, 'email_sent');
      verify(mockAuthService.sendPasswordResetEmail('test@example.com')).called(1);
    });
  });
}