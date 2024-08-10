package com.moodmix.app.frontend_temp;

import android.content.Context;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;

import java.io.InputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;

import org.deeplearning4j.nn.multilayer.MultiLayerNetwork;

public class NeuralNetService {
    private Context context;

    public NeuralNetService(Context context) {
        this.context = context;
    }

    public String getMood(byte[] imageBytes) {
        InputStream inputStream = new ByteArrayInputStream(imageBytes);
        Bitmap bitmap = BitmapFactory.decodeStream(inputStream);

        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);

        return "Doing stuff with image";
    }
}