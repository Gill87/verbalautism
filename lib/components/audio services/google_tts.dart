import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:audioplayers/audioplayers.dart';

class GoogleTTS {
  static final GoogleTTS _instance = GoogleTTS._internal();
  factory GoogleTTS() => _instance;

  GoogleTTS._internal();

  late ServiceAccountCredentials _credentials;
  AutoRefreshingAuthClient? _client;

  Future<void> init(String jsonKeyPath) async {
    if (_client != null) return; // already initialized

    final jsonString = await rootBundle.loadString(jsonKeyPath);
    _credentials = ServiceAccountCredentials.fromJson(json.decode(jsonString));

    final scopes = ['https://www.googleapis.com/auth/cloud-platform'];
    _client = await clientViaServiceAccount(_credentials, scopes);
  }

  Future<void> speak(String text) async {
    if (_client == null) {
      throw Exception("GoogleTTS not initialized. Call init() first.");
    }

    final request = {
      "input": {"text": text},
      "voice": {"languageCode": "en-US", "name": "en-US-Standard-C"},
      "audioConfig": {"audioEncoding": "LINEAR16"} // Try LINEAR16 first
    };

    final response = await _client!.post(
      Uri.parse("https://texttospeech.googleapis.com/v1/text:synthesize"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      final audioContent = json.decode(response.body)['audioContent'];
      final bytes = base64Decode(audioContent);

      final player = AudioPlayer();
      await player.play(BytesSource(Uint8List.fromList(bytes)));
    } else {
      throw Exception("TTS failed: ${response.body}");
    }
  }
}
