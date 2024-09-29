class MoodService {
  static final MoodService _instance = MoodService._internal();
  String _mood = "";

  factory MoodService() {
    return _instance;
  }

  MoodService._internal();

  String get mood => _mood;

  void setMood(String mood) {
    _mood = mood;
  }

}
