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

//import javax.swing.*;
import java.io.File;
import java.util.Arrays;
import java.util.List;

import java.io.IOException;
import android.content.Context;
import android.content.res.AssetManager;

//import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;

import android.util.Log;



import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import org.tensorflow.lite.Interpreter;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import org.tensorflow.lite.Interpreter;





public class NeuralNetService {
    private Context context;
    private Interpreter tflite;

    public NeuralNetService(Context context) {
        this.context = context;
  //      loadModel();
    }



    public byte[] convertInputStreamToByteArray(InputStream inputStream) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        int nRead;
        byte[] data = new byte[16384]; // 16KB buffer

        while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }

        buffer.flush();
        return buffer.toByteArray();
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





    private MappedByteBuffer loadModelFile(AssetManager assetManager, String modelPath) throws IOException {
        try (AssetFileDescriptor fileDescriptor = assetManager.openFd(modelPath)) {
            FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
            FileChannel fileChannel = inputStream.getChannel();
            long startOffset = fileDescriptor.getStartOffset();
            long declaredLength = fileDescriptor.getDeclaredLength();
            return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
        }
    }




    public String getMood(byte[] imageBytes) {



        Bitmap bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.length);

        // Step 2: Preprocess the Bitmap
        Bitmap resizedBitmap = Bitmap.createScaledBitmap(bitmap, 48, 48, true);

        // Convert to grayscale if necessary
        int width = resizedBitmap.getWidth();
        int height = resizedBitmap.getHeight();
        float[][][][] inputData = new float[1][48][48][1]; // 1 sample, 48x48 image, 1 channel

        for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {
                // Get pixel value and convert to grayscale
                int pixel = resizedBitmap.getPixel(i, j);
                int grayValue = (int) (0.299 * Color.red(pixel) + 0.587 * Color.green(pixel) + 0.114 * Color.blue(pixel));
                inputData[0][i][j][0] = grayValue / 255.0f; // Normalize to [0, 1]
            }
        }




        try{

            AssetManager assetManager = context.getAssets();
            MappedByteBuffer modelBuffer = loadModelFile(assetManager, "new_model_9_modified_newest.tflite");

            // Create the TFLite interpreter with the MappedByteBuffer
            tflite = new Interpreter(modelBuffer);

            Log.d("NeuralNetService", "MODEL LOADED!!!!!!!!!!!!");

        } catch (IOException e) {
            e.printStackTrace();
            // Handle exceptions here (e.g., model file not found)
        } catch (Exception e) {
            e.printStackTrace();
            // Handle other potential exceptions
        }


//        float[][][][] inputData = new float[1][48][48][1]; // 1 sample, 48x48 image, 1 channel
//
//// Fill inputData with random values or your actual test data
//        for (int i = 0; i < 48; i++) {
//            for (int j = 0; j < 48; j++) {
//                inputData[0][i][j][0] = (float) Math.random(); // Replace with actual data if needed
//            }
//        }
//
//// Prepare output data array


        float[][] outputData = new float[1][3];


        try {
            tflite.run(inputData, outputData); // Run the model with the input data

            // Output the results
            Log.d("NeuralNetService", "Inference Output: " + Arrays.toString(outputData[0]));
        } catch (Exception e) {
            e.printStackTrace();
        }

        //[0.32354924, 0.35912168, 0.3173291]

        String[] emotions = {"angry", "happy", "sad"};

        int current_highest_index = 0;
        float current_highest_value = 0;

        for(int i = 0; i < 3; i++){
            if(outputData[0][i] > current_highest_value){
                current_highest_index = i;
                current_highest_value = outputData[0][i];
            }
        }


        return emotions[current_highest_index];
    }
}

// red error screen is caused when an exception is thrown in this class, as the
// confirmation_pop_up page's mood list never gets any data, so trying to access
// any of its elements (as in the fetchMood function) will result in the red error screen