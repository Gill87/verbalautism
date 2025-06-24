import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  TtsService() {
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-GB");  // British English
    await _flutterTts.setPitch(1.1);         // Slightly higher pitch
    await _flutterTts.setSpeechRate(0.85);   // More human, slower pace
    await _flutterTts.setVolume(1.0);        // Full volume

    // Optionally pick female British voice if available
    List<dynamic> voices = await _flutterTts.getVoices;
    var selectedVoice = voices.firstWhere(
      (voice) => voice["locale"] == "en-GB" && voice["name"].toString().toLowerCase().contains("female"),
      orElse: () => null,
    );

    if (selectedVoice != null) {
      await _flutterTts.setVoice({
        "name": selectedVoice["name"],
        "locale": selectedVoice["locale"]
      });
    }
  }

  Future<void> speak(String text) async {
    await _flutterTts.stop();  // Stop any ongoing speech
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}