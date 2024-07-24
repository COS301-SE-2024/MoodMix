package com.moodmix.app.frontend_temp;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.spotify.sdk.android.auth.AuthorizationClient;
import com.spotify.sdk.android.auth.AuthorizationRequest;
import com.spotify.sdk.android.auth.AuthorizationResponse;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CLIENT_ID = "efd7d41773d44358aa960b32815fcc10";
    private static final String REDIRECT_URI = "http://localhost:5002/callback";
    private static final int REQUEST_CODE = 1337;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "spotify_auth")
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
        AuthorizationRequest.Builder builder =
                new AuthorizationRequest.Builder(CLIENT_ID, AuthorizationResponse.Type.TOKEN, REDIRECT_URI);
        builder.setScopes(new String[]{"user-read-private", "playlist-read", "playlist-read-private"});
        AuthorizationRequest request = builder.build();
        AuthorizationClient.openLoginActivity(this, REQUEST_CODE, request);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if (requestCode == REQUEST_CODE) {
            AuthorizationResponse response = AuthorizationClient.getResponse(resultCode, intent);
            switch (response.getType()) {
                case TOKEN:
                    // Handle successful response
                    String accessToken = response.getAccessToken();
                    // Pass the access token back to Flutter
                    break;
                case ERROR:
                    // Handle error response
                    break;
                default:
                    // Handle other cases
            }
        }
    }
}
