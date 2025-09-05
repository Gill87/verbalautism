// tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return; // don’t run twice

    await _flutterTts.setPitch(1.1);
    await _flutterTts.setSpeechRate(0.85);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setLanguage("en-GB");

    List<dynamic> voices = await _flutterTts.getVoices;

    var selectedVoice = voices.firstWhere(
      (voice) =>
          voice["locale"] == "en-GB" &&
          voice["name"].toString().toLowerCase().contains("female"),
      orElse: () => null,
    );

    if (selectedVoice != null) {
      print("✅ VOICE FOUND: ${selectedVoice['name']}");
      await _flutterTts.setVoice({
        "name": selectedVoice["name"],
        "locale": selectedVoice["locale"]
      });
    } else {
      print("⚠ No specific female en-GB voice found — using default en-GB.");
    }

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await init(); // ensure voice is ready
    }
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
