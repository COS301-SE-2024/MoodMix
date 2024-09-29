import 'package:flutter/material.dart';
import 'neural_net_service.dart';  // Import the service

class ImageProcessingPage extends StatelessWidget {
  const ImageProcessingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Processing Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            NeuralNetService neuralNetService = NeuralNetService();
            double avgResponseTime = await neuralNetService.processImagesAndGetAverageResponseTime();
            _showAverageResponseTime(context, avgResponseTime);
          },
          child: const Text('Select Images and Get Avg Response Time'),
        ),
      ),
    );
  }

  // Function to show average response time in a dialog
  void _showAverageResponseTime(BuildContext context, double avgResponseTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Average Response Time'),
          content: Text('Average Response Time: $avgResponseTime ms'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
