import 'dart:async';
import 'dart:convert';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:sentiment_dart/sentiment_dart.dart';

class AudioRecorder {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer;
  FlutterSoundRecorder? _mRecorder;
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mPlaybackReady = false;

  AudioRecorder() {
    _mPlayer = FlutterSoundPlayer();
    _mRecorder = FlutterSoundRecorder();
  }

  Future<void> init() async {
    await _mPlayer!.openPlayer();
    _mPlayerIsInited = true;
    await openRecorder();
  }

  Future<void> openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _mRecorder!.openRecorder();
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
    ));
    _mRecorderIsInited = true;
  }

  Future<void> record() async {
    await _mRecorder!.startRecorder(toFile: _mPath, codec: _codec);
  }

  Future<void> stopRecorder() async {
    String? recordedFilePath = await _mRecorder!.stopRecorder();
    if (recordedFilePath != null) {
      _mPlaybackReady = true;
      await transcribeAudioAndAnalyze(recordedFilePath);
    }
  }

  Future<void> transcribeAudioAndAnalyze(String filePath) async {
    final String apiUrl = 'https://api.openai.com/v1/audio/transcriptions';

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..headers['Authorization'] = 'Bearer'
      ..fields['model'] = 'whisper-1'
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(responseData.body);
        String transcription = responseJson['text'];

        // Perform sentiment analysis on the transcription
        Map<String, dynamic> sentimentResult = Sentiment.analysis(transcription) as Map<String, dynamic>;
        int score = sentimentResult['score'];

        // Determine emotion based on the score
        String emotion;
        if (score >= 2) {
          emotion = 'Happy';
        } else if (score <= -2) {
          emotion = 'Angry';
        } else {
          emotion = 'Sad';
        }

        print('Transcription: $transcription');
        print('Sentiment Score: $score');
        print('Emotion: $emotion');
      } else {
        print('Error: ${responseData.body}');
      }
    } catch (e) {
      print('Failed to transcribe audio: $e');
    }
  }




  void dispose() {
    _mPlayer!.closePlayer();
    _mRecorder!.closeRecorder();
  }
}