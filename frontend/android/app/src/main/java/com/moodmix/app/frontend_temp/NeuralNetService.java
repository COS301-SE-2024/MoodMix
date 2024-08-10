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

import javax.swing.*;
import java.io.File;
import java.util.Arrays;
import java.util.List;

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

        List<String> labelList = Arrays.asList("angry", "happy", "neutral", "sad");

        //file choose pop-up

        String fileChose = fileChose().toString();


        log.info("------LOAD TRAINED MODEL------");

        File loadLocation = new File("savedNeuralNet.zip");

        MultiLayerNetwork model = ModelSerializer.restoreMultiLayerNetwork(loadLocation);


        log.info("--------EVALUATE CHOSEN FILE WITH LOADED NEURAL NET--------");

        File file = new File(fileChose);

        // need to convert loaded image to matrix of pixel values

        NativeImageLoader loader = new NativeImageLoader(image_height, image_width, color_channels);

        // load image as INDArray

        INDArray image = loader.asMatrix(file);

        DataNormalization scaler = new ImagePreProcessingScaler(0,1);
        scaler.transform(image);

        INDArray output = model.output(image);  // pass image to neural net

        log.info("---- CHOSEN FILE: " + fileChose);
        log.info("-----NEURAL NET PREDICTION-----");
        log.info("---LIST OF PROBABILITIES PER LABEL");
        log.info("---LIST OF LABELS IN ORDER");
        log.info(output.toString());
        log.info(labelList.toString());



        return "Doing stuff with image";

    }
}