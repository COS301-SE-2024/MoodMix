//package com.moodmix.app.frontend_temp;
//
//import android.content.Context;
//import android.graphics.Color;
//import android.graphics.Canvas;
//import android.graphics.ColorMatrix;
//import android.graphics.ColorMatrixColorFilter;
//import android.graphics.Paint;
//
//
//import android.graphics.Bitmap;
//import android.graphics.BitmapFactory;
//import android.util.Base64;
//
//import java.io.InputStream;
//import java.io.ByteArrayInputStream;
//import java.io.ByteArrayOutputStream;
//
//import org.deeplearning4j.nn.multilayer.MultiLayerNetwork;
//import org.deeplearning4j.util.ModelSerializer;
//import org.nd4j.linalg.dataset.api.preprocessor.DataNormalization;
//import org.nd4j.linalg.dataset.api.preprocessor.ImagePreProcessingScaler;
//import org.nd4j.linalg.api.ndarray.INDArray;
//import org.datavec.image.loader.NativeImageLoader;
//import org.nd4j.linalg.factory.Nd4j;
//
//
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
////import javax.swing.*;
//import java.io.File;
//import java.util.Arrays;
//import java.util.List;
//
//import java.io.IOException;
//import android.content.Context;
//import android.content.res.AssetManager;
//
////import androidx.appcompat.app.AppCompatActivity;
//import android.os.Bundle;
//
//import android.util.Log;
//
//
//
//import android.content.Context;
//import android.content.res.AssetManager;
//import android.graphics.Bitmap;
//import android.graphics.BitmapFactory;
//import android.util.Log;
//
//import org.tensorflow.lite.Interpreter;
//
//import java.io.FileInputStream;
//import java.io.IOException;
//import java.io.InputStream;
//import java.nio.MappedByteBuffer;
//import java.nio.channels.FileChannel;
//
//import android.content.Context;
//import android.content.res.AssetFileDescriptor;
//import android.content.res.AssetManager;
//import java.io.FileInputStream;
//import java.io.IOException;
//import java.nio.MappedByteBuffer;
//import java.nio.channels.FileChannel;
//import org.tensorflow.lite.Interpreter;
//
//
//
//
//
//public class NeuralNetService_old {
//    private Context context;
//    private Interpreter tflite;
//
//    public NeuralNetService_old(Context context) {
//        this.context = context;
//  //      loadModel();
//    }
//
//
//
//    public byte[] convertInputStreamToByteArray(InputStream inputStream) throws IOException {
//        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
//        int nRead;
//        byte[] data = new byte[16384]; // 16KB buffer
//
//        while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
//            buffer.write(data, 0, nRead);
//        }
//
//        buffer.flush();
//        return buffer.toByteArray();
//    }
//
//
//
//
//    public Bitmap convertToGrayscale(Bitmap originalBitmap) {
//        int width, height;
//        height = originalBitmap.getHeight();
//        width = originalBitmap.getWidth();
//
//        Bitmap grayscaleBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);
//        Canvas canvas = new Canvas(grayscaleBitmap);
//        Paint paint = new Paint();
//        ColorMatrix colorMatrix = new ColorMatrix();
//        colorMatrix.setSaturation(0);
//        ColorMatrixColorFilter colorFilter = new ColorMatrixColorFilter(colorMatrix);
//        paint.setColorFilter(colorFilter);
//        canvas.drawBitmap(originalBitmap, 0, 0, paint);
//
//        return grayscaleBitmap;
//    }
//
//
//
//    public INDArray bitmapToINDArray(Bitmap grayscaleBitmap) {
//        int height = grayscaleBitmap.getHeight();
//        int width = grayscaleBitmap.getWidth();
//
//        // Create a float array to hold the pixel values
//        float[] pixelValues = new float[height * width];
//
//        // Extract the pixel values
//        int index = 0;
//        for (int y = 0; y < height; y++) {
//            for (int x = 0; x < width; x++) {
//                int pixel = grayscaleBitmap.getPixel(x, y);
//                // Bitmap is already grayscale, so red, green, and blue values are the same
//                // Use the red component, as it's equal to green and blue in grayscale
//                float grayscaleValue = Color.red(pixel);
//                // Store the grayscale value in the array
//                pixelValues[index++] = grayscaleValue / 255.0f;  // Normalize to [0, 1] if needed
//            }
//        }
//
//        // Create an INDArray from the pixel values
//        INDArray indArray = Nd4j.create(pixelValues, new int[]{1, 1, height, width});
//        return indArray;
//    }
//
//
//
//
//
//
//
//
//
//
//
//
//
////    private void loadModel() {
////        try {
////            // Load the model from assets
////            AssetManager assetManager = context.getAssets();
////            InputStream modelInputStream = assetManager.open("model.tflite"); // Replace with your actual model file name
////
////            // Load the TFLite model
////            tflite = new Interpreter(loadModelFile(modelInputStream));
////            Log.d("NeuralNetService", "MODEL LOADED!!!!!!!!!!!!!!!");
////
////        } catch (IOException e) {
////            Log.e("NeuralNetService", "Error loading model", e);
////        }
////    }
////
////    private MappedByteBuffer loadModelFile(InputStream inputStream) throws IOException {
////        FileChannel fileChannel = ((FileInputStream) inputStream).getChannel();
////        long startOffset = 0; // The starting offset in the file
////        long declaredLength = fileChannel.size(); // The total size of the model file
////        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
////    }
//
//
//
//
//
//    private MappedByteBuffer loadModelFile(AssetManager assetManager, String modelPath) throws IOException {
//        try (AssetFileDescriptor fileDescriptor = assetManager.openFd(modelPath)) {
//            FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
//            FileChannel fileChannel = inputStream.getChannel();
//            long startOffset = fileDescriptor.getStartOffset();
//            long declaredLength = fileDescriptor.getDeclaredLength();
//            return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
//        }
//    }
//
//
//
//
//    public String getMood(byte[] imageBytes) {
////        InputStream inputStream = new ByteArrayInputStream(imageBytes);
////        Bitmap bitmap = BitmapFactory.decodeStream(inputStream);
////
//////        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
//////        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);
////
////        if (bitmap == null) {
////            //Log.e("NeuralNetService", "Error: Bitmap is null");
////            System.out.println("asas");
////            return "Error: Bitmap is null";
////        }
////
////        Log.d("NeuralNetService", "Bitmap loaded successfully.");
////
////        int image_height = 48; // pixel size
////        int image_width = 48;  // pixel size
////        int color_channels = 1; // 1 means grayscale
////
////        //List<String> labelList = Arrays.asList("angry", "happy", "neutral", "sad");
////
////        String[] emotions = {"angry", "happy", "sad"};
////
////        // Load the model from assets
////
////        MultiLayerNetwork model = null;
////
////
////
////        try {
////
////
////        //    AssetManager assetManager = context.getAssets();
////
////
////         //   InputStream modelInputStream = assetManager.open("savedNeuralNet.zip");
////
////        //    byte[] modelBytes = convertInputStreamToByteArray(modelInputStream);
////
////            InputStream is = context.getResources().openRawResource(R.raw.small_test);
////            Log.d("ModelLoader", "Model input stream available: " + (inputStream != null));
////            // Load the model using ModelSerializer
////            model = ModelSerializer.restoreMultiLayerNetwork(is);
////
////
////           // Log.d("Output shape: " , output.shapeInfoToString());
////
////            INDArray input = Nd4j.zeros(1, 1 ,48, 48);
////            INDArray layerInput = input;
////
////            INDArray results = model.output(input);
////            System.out.println("Results: "+ results );
////
////            for (int i = 0; i < model.getLayers().length; i++) {
////                // Create input for each layer based on the previous layer's output
////
////                // Get the output of the current layer
////                INDArray layerOutput = model.output(layerInput);
////            //    Log.i("Layer " + i + " (" + model.getLayer(i).getClass().getSimpleName() + ") output shape: " + layerOutput.shapeInfoToString());
////                Log.i("NeuralNetService",model.getLayer(i).getClass().getSimpleName() + "   " + layerOutput.shapeInfoToString());
////            }
////
//////            if (modelInputStream == null) {
//////                Log.e("ModelLoad", "InputStream is null. The model file may not exist.");
//////                return null; // Or handle the error as needed
//////            }
////
////         //   model = ModelSerializer.restoreMultiLayerNetwork(modelInputStream);
////    //        model = ModelSerializer.restoreMultiLayerNetwork(new ByteArrayInputStream(modelBytes));
////      //      modelInputStream.close();
////
////            Log.d("Model Configuration", model.conf().toJson());
////         //   INDArray layerWeights = model.getLayer(0).getParam("W");
////         //   System.out.println("First layer weights: " + layerWeights);
////
////            if (model != null) {
////                Log.i("NeuralNetService", "Model loaded successfully. Number of layers: " + model.getnLayers());
////            } else {
////                Log.e("NeuralNetService", "Error: Model not loaded");
////            }
////
////        } catch (IllegalArgumentException e) {
////            Log.e("NeuralNetService", "Illegal argument while loading model", e);
////        } catch (IOException e) {
////            Log.e("NeuralNetService", "IO error while loading model", e);
////        } catch (Exception e) {
////            Log.e("NeuralNetService", "Unexpected error while loading model", e);
////        }
////   //     Log.i("NeuralNetService", "Model loaded successfully.");
////
////        Bitmap grayscaleBitmap = convertToGrayscale(bitmap);
////        Bitmap scaledGrayscaleBitmap = Bitmap.createScaledBitmap(grayscaleBitmap, image_width, image_height, false);
////
////        INDArray inputArray = bitmapToINDArray(scaledGrayscaleBitmap);
////
////        // Log the shape of the INDArray
////        Log.i("NeuralNetService", "Shape: " + Arrays.toString(inputArray.shape()));
////
////// Log the data in the INDArray
////        Log.i("NeuralNetService", "Data: " + inputArray.toString());
////
//////        NativeImageLoader loader = new NativeImageLoader(image_height, image_width, color_channels);
//////        INDArray image = null;
////
////
////
//////        try {
//////            // Load the image as INDArray
//////            image = loader.asMatrix(inputArray);
//////        } catch (IOException e) {
//////         //   e.printStackTrace();
//////            Log.e("NeuralNetService", "Error loading image", e);
//////            return "Error loading image";
//////        }
////
//////        if (image.shape()[1] != 1 || image.shape()[2] != 48 || image.shape()[3] != 48) {
//////            Log.e("NeuralNetService", "Error: Incorrect image shape");
//////            return "Error: Incorrect image shape";
//////        }
////
////        Log.d("NeuralNetService", "Image loaded and preprocessed successfully.");
////
////     //   DataNormalization scaler = new ImagePreProcessingScaler(0, 1);
////
////      //  scaler.transform(image);  THIS BREAKS CURRENT IMPLEMENTATION AS IMAE IS AN INDARRAY
////
////    //    image = image.reshape(1, 1, 48, 48);
////
////        //INDArray output = model.output(inputArray);  // Pass image to neural net
////         // Reshaping to the expected format if necessary
////
////
//////        float highestProbability = Float.MIN_VALUE;
//////        int highestProbabilityIndex = -1;
//////
//////        for (int i = 0; i < output.length(); i++) {
//////            float currentProbability = output.getFloat(i);
//////            if (currentProbability > highestProbability) {
//////                highestProbability = currentProbability;
//////                highestProbabilityIndex = i;
//////            }
//////        }
////    //    Log.i("NeuralNetService", "Predicted emotion: " + emotions[highestProbabilityIndex]);
////     //  return emotions[highestProbabilityIndex];
////
////
////      //  throw new IllegalArgumentException("Your error message here");
////      //  Log.d("ModelLoader", "Model input stream available: " + (inputStream != null));
//
//
//
//
//
//
//        Bitmap bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.length);
//
//        // Step 2: Preprocess the Bitmap
//        Bitmap resizedBitmap = Bitmap.createScaledBitmap(bitmap, 48, 48, true);
//
//        // Convert to grayscale if necessary
//        int width = resizedBitmap.getWidth();
//        int height = resizedBitmap.getHeight();
//        float[][][][] inputData = new float[1][48][48][1]; // 1 sample, 48x48 image, 1 channel
//
//        for (int i = 0; i < width; i++) {
//            for (int j = 0; j < height; j++) {
//                // Get pixel value and convert to grayscale
//                int pixel = resizedBitmap.getPixel(i, j);
//                int grayValue = (int) (0.299 * Color.red(pixel) + 0.587 * Color.green(pixel) + 0.114 * Color.blue(pixel));
//                inputData[0][i][j][0] = grayValue / 255.0f; // Normalize to [0, 1]
//            }
//        }
//
//
//
//
//        try{
//
//            AssetManager assetManager = context.getAssets();
//            MappedByteBuffer modelBuffer = loadModelFile(assetManager, "new_model_9_modified_newest.tflite");
//
//            // Create the TFLite interpreter with the MappedByteBuffer
//            tflite = new Interpreter(modelBuffer);
//
//            Log.d("NeuralNetService", "MODEL LOADED!!!!!!!!!!!!");
//
//        } catch (IOException e) {
//            e.printStackTrace();
//            // Handle exceptions here (e.g., model file not found)
//        } catch (Exception e) {
//            e.printStackTrace();
//            // Handle other potential exceptions
//        }
//
//
////        float[][][][] inputData = new float[1][48][48][1]; // 1 sample, 48x48 image, 1 channel
////
////// Fill inputData with random values or your actual test data
////        for (int i = 0; i < 48; i++) {
////            for (int j = 0; j < 48; j++) {
////                inputData[0][i][j][0] = (float) Math.random(); // Replace with actual data if needed
////            }
////        }
////
////// Prepare output data array
//
//
//        float[][] outputData = new float[1][3];
//
//
//        try {
//            tflite.run(inputData, outputData); // Run the model with the input data
//
//            // Output the results
//            Log.d("NeuralNetService", "Inference Output: " + Arrays.toString(outputData[0]));
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        //[0.32354924, 0.35912168, 0.3173291]
//
//        String[] emotions = {"angry", "happy", "sad"};
//
//        int current_highest_index = 0;
//        float current_highest_value = 0;
//
//        for(int i = 0; i < 3; i++){
//            if(outputData[0][i] > current_highest_value){
//                current_highest_index = i;
//                current_highest_value = outputData[0][i];
//            }
//        }
//
//
//        return emotions[current_highest_index];
//    }
//}
//
//// red error screen is caused when an exception is thrown in this class, as the
//// confirmation_pop_up page's mood list never gets any data, so trying to access
//// any of its elements (as in the fetchMood function) will result in the red error screen