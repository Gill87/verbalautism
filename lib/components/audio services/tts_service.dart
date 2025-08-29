import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  TtsService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setPitch(1.1);
    await _flutterTts.setSpeechRate(0.85); // Slower and more human
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setLanguage("en-GB");

    List<dynamic> voices = await _flutterTts.getVoices;
    for (int i = 0; i < voices.length; ++i) {
      print(voices[i]);
    }

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
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
