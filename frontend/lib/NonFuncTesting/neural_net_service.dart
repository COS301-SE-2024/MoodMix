import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'dart:io';

class NeuralNetService {
  static const MethodChannel _channel = MethodChannel('neural_net_method_channel');


  Future<double> processImagesAndGetAverageResponseTime() async {
    List<File> selectedFiles = [];
    int totalResponseTime = 0;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null) {
        selectedFiles = result.paths
            .where((path) => path != null)
            .map((path) => File(path!))
            .toList()
            .take(10)
            .toList();
      } else {
        print('No files selected');
        return 0.0;
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
      return 0.0;
    }

    // Step 2: Calculate the average response time
    for (var file in selectedFiles) {
      final stopwatch = Stopwatch()..start();

      try {
        final imageBytes = await file.readAsBytes();
        await _channel.invokeMethod('get_mood', {'image': imageBytes});
      } on PlatformException catch (e) {
        print('Error: ${e.message}');
        continue;
      }

      stopwatch.stop();
      totalResponseTime += stopwatch.elapsedMilliseconds;
    }

    return selectedFiles.isNotEmpty ? totalResponseTime / selectedFiles.length : 0.0;
  }
}
