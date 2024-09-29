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


            tflite = new Interpreter(modelBuffer);

            Log.d("NeuralNetService", "MODEL LOADED!!!!!!!!!!!!");

        } catch (IOException e) {
            e.printStackTrace();

        } catch (Exception e) {
            e.printStackTrace();

        }



        float[][] outputData = new float[1][3];


        try {
            tflite.run(inputData, outputData); // run the model with the input data

            // output the results
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
