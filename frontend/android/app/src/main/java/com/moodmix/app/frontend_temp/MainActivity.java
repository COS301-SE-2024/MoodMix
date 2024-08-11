package com.moodmix.app.frontend_temp;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import android.net.Uri;

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
    private static final String NEURAL_NET_CHANNEL = "neural_net_method_channel";


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

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), NEURAL_NET_CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("get_mood")) {
                                byte[] image_bytes = call.argument("image");
                                NeuralNetService neuralNetService = new NeuralNetService(this);

                                if (image_bytes != null) {
                                    String mood_result = neuralNetService.getMood(image_bytes);
                                    System.out.println("MOODRESULT IS AS FOLLOWS:");
                                    System.out.println(mood_result);
                                    sendMood(mood_result);
                                    result.success(mood_result);
                                } else {
                                    result.error("UNAVAILABLE", "Image bytes failed", "null");
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private void sendMood(String mood) {

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), NEURAL_NET_CHANNEL)
                .invokeMethod("recieveMood", mood); // Method to send access token to Flutter
    }





    private void authenticate() {
        AuthorizationRequest.Builder builder =
                new AuthorizationRequest.Builder(CLIENT_ID, AuthorizationResponse.Type.TOKEN, REDIRECT_URI);
        builder.setScopes(new String[]{"user-read-private, user-read-email,  playlist-read-collaborative, playlist-modify-public, streaming, user-top-read"});
        AuthorizationRequest request = builder.build();
        System.out.println("Login authentication will now happen");
        AuthorizationClient.openLoginActivity(this, REQUEST_CODE, request);

    }


    private void authenticateViaBrowser() {
        AuthorizationRequest.Builder builder = new AuthorizationRequest.Builder(CLIENT_ID, AuthorizationResponse.Type.TOKEN, REDIRECT_URI);
        builder.setScopes(new String[]{"user-read-private, user-read-email,  playlist-read-collaborative, playlist-modify-public, streaming, user-top-read"});
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
                    String accessToken = response.getAccessToken();
                    sendResultToFlutter(accessToken); // Sending access token to Flutter
                    System.out.println(accessToken);
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
}
