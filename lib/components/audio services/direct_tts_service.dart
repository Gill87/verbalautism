import 'package:web/web.dart' as web;
import 'dart:js_interop';

class DirectTtsService {

  static void listVoices() {
    final synth = web.window.speechSynthesis;
    final voices = synth.getVoices().toDart;

    for (var v in voices) {
      print("Voiceee: ${v.name}, Lang: ${v.lang}");
    }
  }

  static void speakText(String text) {
    final synth = web.window.speechSynthesis;

    // Cancel anything already speaking
    synth.cancel();

    // Create the utterance
    final utterance = web.SpeechSynthesisUtterance(text);

    // Optional: set voice (depends on OS/browser)
    final voices = synth.getVoices().toDart;
    if (voices.isNotEmpty) {
      utterance.voice = voices.firstWhere(
        (v) => v.lang.startsWith("en-GB"),
        orElse: () => voices.first,
      );
    }

    // Settings
    utterance.rate = 1.0;
    utterance.pitch = 1.0;
    utterance.volume = 1.0;

    // Speak it
    synth.speak(utterance);
  }
}