package com.moodmix.app.frontend_temp;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Canvas;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;


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
import org.nd4j.linalg.factory.Nd4j;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

//import javax.swing.*;
import java.io.File;
import java.util.Arrays;
import java.util.List;

import java.io.IOException;
import android.content.Context;
import android.content.res.AssetManager;

import android.util.Log;

public class NeuralNetService {
    private Context context;

    public NeuralNetService(Context context) {
        this.context = context;
    }


    public Bitmap convertToGrayscale(Bitmap originalBitmap) {
        int width, height;
        height = originalBitmap.getHeight();
        width = originalBitmap.getWidth();

        Bitmap grayscaleBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);
        Canvas canvas = new Canvas(grayscaleBitmap);
        Paint paint = new Paint();
        ColorMatrix colorMatrix = new ColorMatrix();
        colorMatrix.setSaturation(0);
        ColorMatrixColorFilter colorFilter = new ColorMatrixColorFilter(colorMatrix);
        paint.setColorFilter(colorFilter);
        canvas.drawBitmap(originalBitmap, 0, 0, paint);

        return grayscaleBitmap;
    }



    public INDArray bitmapToINDArray(Bitmap grayscaleBitmap) {
        int height = grayscaleBitmap.getHeight();
        int width = grayscaleBitmap.getWidth();

        // Create a float array to hold the pixel values
        float[] pixelValues = new float[height * width];

        // Extract the pixel values
        int index = 0;
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int pixel = grayscaleBitmap.getPixel(x, y);
                // Bitmap is already grayscale, so red, green, and blue values are the same
                // Use the red component, as it's equal to green and blue in grayscale
                float grayscaleValue = Color.red(pixel);
                // Store the grayscale value in the array
                pixelValues[index++] = grayscaleValue / 255.0f;  // Normalize to [0, 1] if needed
            }
        }

        // Create an INDArray from the pixel values
        INDArray indArray = Nd4j.create(pixelValues, new int[]{1, 1, height, width});
        return indArray;
    }


    public String getMood(byte[] imageBytes) {
        InputStream inputStream = new ByteArrayInputStream(imageBytes);
        Bitmap bitmap = BitmapFactory.decodeStream(inputStream);

//        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
//        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);

        if (bitmap == null) {
            //Log.e("NeuralNetService", "Error: Bitmap is null");
            System.out.println("asas");
            return "Error: Bitmap is null";
        }

        Log.d("NeuralNetService", "Bitmap loaded successfully.");

        int image_height = 48; // pixel size
        int image_width = 48;  // pixel size
        int color_channels = 1; // 1 means grayscale

        //List<String> labelList = Arrays.asList("angry", "happy", "neutral", "sad");

        String[] emotions = {"angry", "happy", "sad"};

        // Load the model from assets

        MultiLayerNetwork model = null;
        try {
            AssetManager assetManager = context.getAssets();
            InputStream modelInputStream = assetManager.open("savedNeuralNet_newest.zip");
            model = ModelSerializer.restoreMultiLayerNetwork(modelInputStream);

            Log.d("Model Configuration", model.conf().toJson());

            if (model != null) {
                Log.i("NeuralNetService", "Model loaded successfully. Number of layers: " + model.getnLayers());
            } else {
                Log.e("NeuralNetService", "Error: Model not loaded");
            }

        } catch (IllegalArgumentException e) {
            Log.e("NeuralNetService", "Illegal argument while loading model", e);
        } catch (IOException e) {
            Log.e("NeuralNetService", "IO error while loading model", e);
        } catch (Exception e) {
            Log.e("NeuralNetService", "Unexpected error while loading model", e);
        }
        Log.i("NeuralNetService", "Model loaded successfully.");

        Bitmap grayscaleBitmap = convertToGrayscale(bitmap);
        Bitmap scaledGrayscaleBitmap = Bitmap.createScaledBitmap(grayscaleBitmap, image_width, image_height, false);

        INDArray inputArray = bitmapToINDArray(scaledGrayscaleBitmap);

        // Log the shape of the INDArray
        Log.i("NeuralNetService", "Shape: " + Arrays.toString(inputArray.shape()));

// Log the data in the INDArray
        Log.i("NeuralNetService", "Data: " + inputArray.toString());

//        NativeImageLoader loader = new NativeImageLoader(image_height, image_width, color_channels);
//        INDArray image = null;



//        try {
//            // Load the image as INDArray
//            image = loader.asMatrix(inputArray);
//        } catch (IOException e) {
//         //   e.printStackTrace();
//            Log.e("NeuralNetService", "Error loading image", e);
//            return "Error loading image";
//        }

//        if (image.shape()[1] != 1 || image.shape()[2] != 48 || image.shape()[3] != 48) {
//            Log.e("NeuralNetService", "Error: Incorrect image shape");
//            return "Error: Incorrect image shape";
//        }

        Log.d("NeuralNetService", "Image loaded and preprocessed successfully.");

     //   DataNormalization scaler = new ImagePreProcessingScaler(0, 1);

      //  scaler.transform(image);  THIS BREAKS CURRENT IMPLEMENTATION AS IMAE IS AN INDARRAY

    //    image = image.reshape(1, 1, 48, 48);

        //INDArray output = model.output(inputArray);  // Pass image to neural net
         // Reshaping to the expected format if necessary


//        float highestProbability = Float.MIN_VALUE;
//        int highestProbabilityIndex = -1;
//
//        for (int i = 0; i < output.length(); i++) {
//            float currentProbability = output.getFloat(i);
//            if (currentProbability > highestProbability) {
//                highestProbability = currentProbability;
//                highestProbabilityIndex = i;
//            }
//        }
    //    Log.i("NeuralNetService", "Predicted emotion: " + emotions[highestProbabilityIndex]);
     //  return emotions[highestProbabilityIndex];


      //  throw new IllegalArgumentException("Your error message here");
        return "angry";
    }
}

// red error screen is caused when an exception is thrown in this class, as the
// confirmation_pop_up page's mood list never gets any data, so trying to access
// any of its elements (as in the fetchMood function) will result in the red error screen