package com.example.frontend

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

import boofcv.abst.fiducial.calib.ConfigSquareGrid
import boofcv.factory.fiducial.FactoryFiducial
import boofcv.io.image.ConvertBitmap
import boofcv.io.image.ConvertImage
import boofcv.struct.image.GrayU8
import boofcv.struct.image.Planar
import boofcv.alg.filter.binary.GThresholdImageOps
import boofcv.alg.filter.binary.ThresholdSquareBlockMinMax
import boofcv.alg.fiducial.calib.grid.DetectSquareGridFiducial

import java.io.ByteArrayOutputStream
import java.util.Base64


class MainActivity: FlutterActivity(){

    override fun configureFlutterEngine(flutterEngine: FlutterEngine){
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        super.configureFlutterEngine(flutterEngine)
        private val CHANNEL = 'boofcvChannel';

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler{call, result ->
                when(call.method){
                    "convertGrayScale" ->{
                        val base64Image: String = call.argument("image")
                        val resultImage: String = convertGrayScale(base64Image)
                        result.success(resultImage)
                    }
                }
            }
    }

    private fun convertGrayScale(img: String): String {
        val outputImgPath = "/assets/images/grayScale.jpeg"
        // println("Line 56 ConvertGrayScale")
        try {
            val colorImage: BufferedImage = UtilImageIO.loadImageNotNull(UtilIO.pathExample(img))
            gray = ConvertBufferedImage.convertFromSingle(colorImage, null, GrayU8::class.java)

            // if(colorImage == null){
            //     System.err.println("Error loading image.");
            //     return;
            // }

            // BufferedImage grayImage = new BufferedImage(colorImage.getWidth(), colorImage.getHeight, BufferedImage.TYPE_BYTE_GRAY);
            // ColorConvertOp op = new ColorConvertOp(colorImage.getColorModel().getColorSpace(), grayImage.getColorModel().getColorSpace(), null);
            // op.filter(colorImage, grayImage);

            UtilImageIO.saveImage(grayImage, outputImgPath)
        } catch (e: IOException) {
            java.lang.System.err.println("error with saving grayscale")
        }

        return outputImgPath
    }

}
