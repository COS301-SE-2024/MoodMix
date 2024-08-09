import 'package:flutter/material.dart';

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

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
      if (isRecording) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 1.0;
      }
    });
    widget.onPressed();
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
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isRecording ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 40.0,
            ),
          ),
        ),
      ),
    );
  }
}
