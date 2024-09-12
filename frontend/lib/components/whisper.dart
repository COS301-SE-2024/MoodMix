import "dart:io";
import "package:whisper_dart/scheme/scheme.dart";
import "package:whisper_dart/whisper_dart.dart";
import 'package:sentiment_dart/sentiment_dart.dart';

void main(List<String> args) async {

  Transcribe transcribe = await whisper.transcribe(
    audio: "./path_file_audio_wav_16_bit",
    model: "./path_model_whisper_bin",
    language: "eng", 
  );
  
  Sentiment.analysis(transcribe, languageCode: 'en');

}