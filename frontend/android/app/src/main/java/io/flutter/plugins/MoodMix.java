package io.flutter.plugins;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import boofcv.abst.fiducial.calib.ConfigSquareGrid;
import boofcv.factory.fiducial.FactoryFiducial;
import boofcv.io.image.ConvertBitmap;
import boofcv.io.image.ConvertImage;
import boofcv.struct.image.GrayU8;
import boofcv.struct.image.Planar;
import boofcv.alg.filter.binary.GThresholdImageOps;
import boofcv.alg.filter.binary.ThresholdSquareBlockMinMax;
import boofcv.alg.fiducial.calib.grid.DetectSquareGridFiducial;

import java.io.ByteArrayOutputStream;
import java.util.Base64;

public class MoodMix extends FlutterActivity {
    //could be io.flutter.plugins/boofcv_channel
    private static final String CHANNEL = "io.flutter.plugins/boofcv_channel";
    //to differentiate with other grayscale converted images
    private int count = 0;
    GrayU8 gray;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), 'io.flutter.plugins/boofcv_channel')
                .setMethodCallHandler(
                        new MethodCallHandler(){
                            @Override
                            public void onMethodCall(MethodCall call, Result result){
                                Log.d("MethodChannel", "Method call Initial");
                                if (call.method.equals("detectFaces")) {
                                    String base64Image = call.argument("image");
                                    String resultImage = detectFaces(base64Image);
                                    result.success(resultImage);
                                }
                                else if(call.method.equals("convertGrayScale")){
                                    Log.d("MethodChannel", "Proccessing Gray Scale");
                                    String base64Image = call.argument("image");
                                    String resultImage = convertGrayScale(base64Image);
                                    result.success(resultImage);
                                } 
                                else {
                                    result.notImplemented();
                                }
                            }
                        }
                );
    }

    private String convertGrayScale(String img){
        Log.d("MethodChannel", "ConvertGrayScale");
        count += 1;
        String outputImgPath = "/assets/images/grayScale.jpeg";
        System.out.println("Line 56 ConvertGrayScale");
        try{
            BufferedImage colorImage = UtilImageIO.loadImageNotNull(UtilIO.pathExample(img));
            gray = ConvertBufferedImage.convertFromSingle(colorImage, null, GrayU8.class);
            // if(colorImage == null){
            //     System.err.println("Error loading image.");
            //     return;
            // }

            // BufferedImage grayImage = new BufferedImage(colorImage.getWidth(), colorImage.getHeight, BufferedImage.TYPE_BYTE_GRAY);
            // ColorConvertOp op = new ColorConvertOp(colorImage.getColorModel().getColorSpace(), grayImage.getColorModel().getColorSpace(), null);
            // op.filter(colorImage, grayImage);

            UtilImageIO.saveImage(grayImage,outputImgPath);

        }
        catch(IOException e){
            System.err.println("error with saving grayscale");
        }

        return outputImgPath;
    }

    private String detectFaces(String base64Image) {
        byte[] imageBytes = Base64.getDecoder().decode(base64Image);
        Bitmap bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.length);

        Planar<GrayU8> colorImage = ConvertBitmap.bitmapToPlanar(bitmap, null, GrayU8.class, null);
        GrayU8 grayImage = ConvertImage.average(colorImage, null);

        // Face detection using BoofCV
        DetectSquareGridFiducial<GrayU8> detector = FactoryFiducial.squareGrid(new ConfigSquareGrid(4, 3), GrayU8.class);

        detector.process(grayImage);
        List<Quadrilateral_F64> detectedFaces = detector.getFoundGrids();

        for (Quadrilateral_F64 face : detectedFaces) {
            // Draw rectangle around detected face
            Bitmap tempBitmap = bitmap.copy(Bitmap.Config.ARGB_8888, true);
            Canvas canvas = new Canvas(tempBitmap);
            Paint paint = new Paint();
            paint.setColor(Color.GREEN);
            paint.setStrokeWidth(5);

            canvas.drawRect(
                    (float) face.a.x, (float) face.a.y,
                    (float) face.c.x, (float) face.c.y,
                    paint
            );

            bitmap = tempBitmap;
        }

        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 90, byteArrayOutputStream);
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        return Base64.getEncoder().encodeToString(byteArray);
    }
}
