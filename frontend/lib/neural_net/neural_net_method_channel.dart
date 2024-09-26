import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class NeuralNetMethodChannel {

  static const MethodChannel _channel = MethodChannel('neural_net_method_channel');
  String mood = "angry";

  Future<String> get_mood(XFile? image) async {

    try {
      if (image != null)
        {

      final imageBytes = await image.readAsBytes();
      final result = await _channel.invokeMethod('get_mood', {'image' : imageBytes});
      print('neural_net method channel result: $result');
      final mood = await result;
      return result;
        } else {
        return "";
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
      return "";
    }
  }

  String returnMood(){
    print("${mood}EASY TO FIND");
    return mood;
  }

}