import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerPage extends StatefulWidget {
  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  String audioUrl = 'assets/songs/song.mp3'; // Adjust path as per your project structure
  late Timer _timer;
  int _currentSeconds = 0;
  Duration _position = Duration.zero; // To store current playback position

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listeners for audio player
    _audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        isPlaying = false;
        _currentSeconds = 0;
        _position = Duration.zero; // Reset position on completion
      });
      _timer.cancel(); // Stop the timer on completion
    });

    _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        isPlaying = false;
      });
    });

    // Listen for audio position changes
    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        _currentSeconds = duration.inSeconds;
      });
    });
  }

  void _playPause() async {
    if (isPlaying) {
      // Pause the audio
      await _audioPlayer.pause();
      _timer.cancel(); // Cancel the timer
    } else {
      if (_position == Duration.zero) {
        // If it's the first play or resumed from the beginning
        int result = await _audioPlayer.play(audioUrl, isLocal: true);
        if (result == 1) {
          // Success
          _startTimer();
        } else {
          // Handle failure to play audio
          print('Failed to play audio');
        }
      } else {
        // Resume from the stored position
        int result = await _audioPlayer.seek(_position);
        if (result == 1) {
          // Success
          await _audioPlayer.resume();
          _startTimer();
        } else {
          // Handle failure to resume
          print('Failed to resume audio');
        }
      }
    }
    setState(() {
      isPlaying = !isPlaying;
      if (!isPlaying) {
        // Reset timer and current playback position when paused
        _timer.cancel();
        _currentSeconds = 0;
      }
    });
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_currentSeconds < 242) {
            _currentSeconds++;
          } else {
            timer.cancel();
          }
        });
      },
    );
  }

  @override
Widget build(BuildContext context) {
  String currentTime = _currentSeconds != null
      ? '${(_currentSeconds ~/ 60).toString().padLeft(2, '0')}:${(_currentSeconds % 60).toString().padLeft(2, '0')}'
      : '00:00';

  double progress = (_currentSeconds / 242);

  return Scaffold(
    appBar: AppBar(
      title: Text('Audio Player'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          _audioPlayer.pause(); // Pause audio before navigating back
          Navigator.pushReplacementNamed(context, '/camera'); // Navigate back to /homepage
        },
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/album_cover.jpg', // Replace with your image path
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text(
            currentTime,
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(height: 10),
          Container(
            width: 250, // Adjust width as per your preference
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ),
          SizedBox(height: 20),
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            iconSize: 64.0,
            onPressed: _playPause,
          ),
        ],
      ),
    ),
  );
}

}



