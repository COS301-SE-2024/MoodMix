package com.moodmix.app.frontend_temp;

import android.content.Context;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;

import java.io.InputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;

import org.deeplearning4j.nn.multilayer.MultiLayerNetwork;
import org.deeplearning4j.util.ModelSerializer;
import org.nd4j.linalg.dataset.api.preprocessor.DataNormalization;
import org.nd4j.linalg.dataset.api.preprocessor.ImagePreProcessingScaler;
import org.nd4j.linalg.api.ndarray.INDArray;
import org.datavec.image.loader.NativeImageLoader;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

//import javax.swing.*;
import java.io.File;
import java.util.Arrays;
import java.util.List;

import java.io.IOException;
import android.content.Context;
import android.content.res.AssetManager;

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

        int image_height = 48; // pixel size
        int image_width = 48;  // pixel size
        int color_channels = 1; // 1 means grayscale

        //List<String> labelList = Arrays.asList("angry", "happy", "neutral", "sad");

        String[] emotions = {"angry", "happy", "neutral", "sad"};

        // Load the model from assets
        MultiLayerNetwork model = null;
        try {
            AssetManager assetManager = context.getAssets();
            InputStream modelInputStream = assetManager.open("savedNeuralNet.zip");
            model = ModelSerializer.restoreMultiLayerNetwork(modelInputStream);
        } catch (IOException e) {
            e.printStackTrace();
            return "Error loading model";
        }

    //    String fileChose = "face_test.jfif";
    //    File file = new File(fileChose);

        NativeImageLoader loader = new NativeImageLoader(image_height, image_width, color_channels);
        INDArray image = null;

        try {
            // Load the image as INDArray
            image = loader.asMatrix(bitmap);
        } catch (IOException e) {
            e.printStackTrace();
            return "Error loading image";
        }

        DataNormalization scaler = new ImagePreProcessingScaler(0, 1);
        scaler.transform(image);

        INDArray output = model.output(image);  // Pass image to neural net

        float highestProbability = Float.MIN_VALUE;
        int highestProbabilityIndex = -1;

        for (int i = 0; i < output.length(); i++) {
            float currentProbability = output.getFloat(i);
            if (currentProbability > highestProbability) {
                highestProbability = currentProbability;
                highestProbabilityIndex = i;
            }
        }

        return emotions[highestProbabilityIndex];
    }
}