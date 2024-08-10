import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class NeuralNetMethodChannel {

  static const MethodChannel _channel = MethodChannel('neural_net_method_channel');

  Future<String> get_mood(XFile? image) async {
    try {
      if (image != null)
        {

      final image_bytes = await image.readAsBytes();
      final result = await _channel.invokeMethod('get_mood', {'image' : image_bytes});
      print('neural_net method channel result: $result');
      return result;
        } else {
        return "";
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
      return "";
    }
  }
}