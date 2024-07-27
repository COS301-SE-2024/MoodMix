package com.moodmix.app.frontend_temp;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.spotify.sdk.android.auth.AuthorizationClient;
import com.spotify.sdk.android.auth.AuthorizationRequest;
import com.spotify.sdk.android.auth.AuthorizationResponse;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;



public class MainActivity extends FlutterActivity {
    private static final String CLIENT_ID = "90b2121e252f449581e909b61e3e6ddb";
    private static final String REDIRECT_URI = "moodmix://callback";
    private static final int REQUEST_CODE = 1337;
    private static final String CHANNEL = "spotify_auth";


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
        AuthorizationRequest.Builder builder =
                new AuthorizationRequest.Builder(CLIENT_ID, AuthorizationResponse.Type.TOKEN, REDIRECT_URI);
        builder.setScopes(new String[]{"user-read-private", "playlist-read", "playlist-read-private"});
        AuthorizationRequest request = builder.build();
        System.out.println("Login authentication will now happen");
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
                    sendResultToFlutter(accessToken);
                    System.out.println("--------------------------------------------------------------------------------\n");
                    System.out.println("Access Token: " + accessToken);
                    break;
                case ERROR:
                    // Handle error response
                    System.out.println("Could not get the token?");
                    sendErrorToFlutter(response.getError());
                    break;
                default:
                    // Handle other cases
                    break;
            }
        }
    }

    private void sendResultToFlutter(String accessToken) {
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                .invokeMethod("onSuccess", accessToken);
    }

    private void sendErrorToFlutter(String error) {
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                .invokeMethod("onError", error);
    }
}
