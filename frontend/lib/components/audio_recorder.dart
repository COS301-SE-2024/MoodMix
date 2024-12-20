import 'package:flutter/material.dart';
import 'package:frontend/mood_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'confirm_pop_up.dart';

class AudioRecorder extends StatefulWidget {
  final VoidCallback onPressed;

  const AudioRecorder({Key? key, required this.onPressed}) : super(key: key);

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> with SingleTickerProviderStateMixin {
  bool isRecording = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String transcript = "";
  String mood = "";
  bool isRecording1 = false;

  Future<void> recordAudio() async {
    setState(() {
      isRecording1 = true;
    });

    final response = await http.post(
      Uri.parse('https://alexpret85.pythonanywhere.com/record'),
    );

    setState(() {
      isRecording1 = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      setState(() {
        transcript = data['transcript'] ?? 'No transcript';
        mood = data['mood'] ?? 'No mood';
      });
      _showConfirmAudio(transcript);
      MoodService().setMood(mood);
    } else {
      setState(() {
        transcript = 'Error: ${response.body}';
        mood = '';
      });
    }
  }

  void _toggleRecording() {
    recordAudio();
    setState(() {
      isRecording = true;
      _controller.repeat(reverse: true);
    });

    widget.onPressed();

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isRecording = false;
        _controller.stop();
        _controller.value = 1.0;
      });
    });
  }

  void _showConfirmAudio(String transcribedText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationPopUp(
          transcribedText: transcribedText,
          moods: ['happy'],
          isImage: false, // Audio confirmation
        );
      },
    ).then((_) {
      setState(() {
        // Reset any necessary variables
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleRecording,
      child: ScaleTransition(
        scale: _controller.drive(
          Tween<double>(begin: 1.0, end: 1.2).chain(
            CurveTween(curve: Curves.elasticOut),
          ),
        ),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: isRecording
                ? Theme
                .of(context)
                .colorScheme
                .secondary
                : Theme
                .of(context)
                .colorScheme
                .secondary
                .withOpacity(1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary,
              size: 40.0,
            ),
          ),
        ),
      ),
    );
  }
}
