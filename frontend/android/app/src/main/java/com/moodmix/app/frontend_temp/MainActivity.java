package com.moodmix.app.frontend_temp;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import android.net.Uri;
import android.util.Log;

import com.spotify.sdk.android.auth.AuthorizationClient;
import com.spotify.sdk.android.auth.AuthorizationRequest;
import com.spotify.sdk.android.auth.AuthorizationResponse;

import com.spotify.android.appremote.api.ConnectionParams;
import com.spotify.android.appremote.api.Connector;
import com.spotify.android.appremote.api.SpotifyAppRemote;

import com.spotify.protocol.client.Subscription;
import com.spotify.protocol.types.PlayerState;
import com.spotify.protocol.types.Track;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;



public class MainActivity extends FlutterActivity {
    private static final String CLIENT_ID = "90b2121e252f449581e909b61e3e6ddb";
    private static final String REDIRECT_URI = "moodmix://callback";
    private static final int REQUEST_CODE = 1337;
    private static final String CHANNEL = "spotify_auth";
    private SpotifyAppRemote mSpotifyAppRemote;



    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("authenticate")) {
                                authenticate();
                                result.success(null);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private void authenticate() {
//        AuthorizationRequest.Builder builder =
//                new AuthorizationRequest.Builder(CLIENT_ID, AuthorizationResponse.Type.TOKEN, REDIRECT_URI);
//        builder.setScopes(new String[]{"user-read-private, user-read-email,  playlist-read-collaborative, playlist-modify-public, streaming, app-remote-control"});
//        AuthorizationRequest request = builder.build();
//        System.out.println("Login authentication will now happen");
//        AuthorizationClient.openLoginActivity(this, REQUEST_CODE, request);
        authenticateViaBrowser();

    }


    private void authenticateViaBrowser() {
        AuthorizationRequest.Builder builder = new AuthorizationRequest.Builder(CLIENT_ID, AuthorizationResponse.Type.TOKEN, REDIRECT_URI);
        builder.setScopes(new String[]{"user-read-private, user-read-email,  playlist-read-collaborative, playlist-modify-public, app-remote-control"});
        builder.setShowDialog(true);
        AuthorizationRequest request = builder.build();
        AuthorizationClient.openLoginInBrowser(this, request);



    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);



        Uri uri = intent.getData();
        if (uri != null) {
            AuthorizationResponse response = AuthorizationResponse.fromUri(uri);

           switch (response.getType()) {
                case TOKEN:
                    // Handle successful response
                    String accessToken = response.getAccessToken();
                    sendResultToFlutter(accessToken); // Sending access token to Flutter
                    System.out.println(accessToken);
                    System.out.println("-----------------------------------------------------------");
                    break;
                case ERROR:

                    break;
                default:
                    // Handle other cases
                    break;
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if (requestCode == REQUEST_CODE) {
            AuthorizationResponse response = AuthorizationClient.getResponse(resultCode, intent);
            switch (response.getType()) {
                case TOKEN:
                    // Handle successful response
                    ConnectionParams connectionParams =
                            new ConnectionParams.Builder(CLIENT_ID)
                                    .setRedirectUri(REDIRECT_URI)
                                    .build();

                    Log.d("MainActivity", "Connected! Yay!");
                    System.out.println("We finna try and connect rn");
                    SpotifyAppRemote.connect(this, connectionParams,
                            new Connector.ConnectionListener() {

                                public void onConnected(SpotifyAppRemote spotifyAppRemote) {
                                    mSpotifyAppRemote = spotifyAppRemote;
                                    System.out.println("We are connected");
                                    Log.d("MainActivity", "Connected! Yay!");

                                    // Now you can start interacting with App Remote
                                    connected();

                                }

                                public void onFailure(Throwable throwable) {
                                    Log.e("MyActivity", throwable.getMessage(), throwable);

                                    // Something went wrong when attempting to connect! Handle errors here
                                }
                            });


                    String accessToken = response.getAccessToken();
                    sendResultToFlutter(accessToken); // Sending access token to Flutter

                    System.out.println("-----------------------------------------------------------");
                    break;
                case ERROR:
                    // Handle error response
                    System.out.println("This failed and we will try browser login rn");
                    authenticateViaBrowser();
                    break;
                default:
                    // Handle other cases
                    break;
            }
        }
    }

    private void sendResultToFlutter(String accessToken) {



        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                .invokeMethod("onSuccess", accessToken); // Method to send access token to Flutter
    }


    private void sendErrorToFlutter(String error) {
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                .invokeMethod("onError", error);
    }


    @Override
    protected void onStop() {
        super.onStop();
        SpotifyAppRemote.disconnect(mSpotifyAppRemote);
    }

    private void connected() {
        // Play a playlist
        mSpotifyAppRemote.getPlayerApi().play("spotify:playlist:37i9dQZF1DX2sUQwD7tbmL");

        // Subscribe to PlayerState
        mSpotifyAppRemote.getPlayerApi()
                .subscribeToPlayerState()
                .setEventCallback(playerState -> {
                    final Track track = playerState.track;
                    if (track != null) {
                        Log.d("MainActivity", track.name + " by " + track.artist.name);
                    }
                });
    }
}
