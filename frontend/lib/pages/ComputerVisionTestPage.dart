
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/main.dart'; 
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';

//This is a Page to Compare an Image to its GrayScaled Version 
class CVPage extends StatefulWidget{
  static const platform = MethodChannel('io.flutter.plugins/boofcv_channel');
  const CVPage({Key? key}): super(key:key);

  //io.flutter.plugins/boofcv_channel
  // static const platform = MethodChannel('boofcv_channel');

  @override
  State<CVPage> createState() => _CVPage(); 
}

class _CVPage extends State<CVPage>{

  void initState(){
    setState(() {
      
    });
  }

  //Could make it return a String of the grayscale?
  Future<void> processImage(String imagePath) async{
    try{
      final String result = await CVPage.platform.invokeMethod('convertGrayScale',{'image':imagePath});
      print(result);
    }
    on PlatformException catch (e){
      print("failed to process");
    }
  }

  
  //A Container with Two Images One Gray Scale the other is the original
  Widget build(BuildContext context){
    print("Print Before Call of ProcessImage");
    processImage('assets/images/images.jpeg');
    print("Print After Call of ProcessImage");
    return Scaffold(
      body:SafeArea(
        child:Center(
          child:Container(
            padding: EdgeInsets.all(20),
            child:Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/images.jpeg')),
              SizedBox(height: 20),
              Image(image: AssetImage('assets/images/grayscale.jpeg')),
            ],
            )
          )
        ),
      )
    );
  }

}