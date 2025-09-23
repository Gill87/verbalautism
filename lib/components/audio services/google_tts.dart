import 'dart:convert';
import 'dart:typed_data';
import 'dart:collection';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:crypto/crypto.dart';

class GoogleTTS {
  static final GoogleTTS _instance = GoogleTTS._internal();
  factory GoogleTTS() => _instance;
  
  GoogleTTS._internal();
  
  late ServiceAccountCredentials _credentials;
  AutoRefreshingAuthClient? _client;
  
  // Audio caching
  final Map<String, Uint8List> _audioCache = {};
  static const int _maxCacheSize = 50; // Adjust based on memory constraints
  final Queue<String> _cacheKeys = Queue<String>();
  
  // Audio queue for sequential playback
  final Queue<Uint8List> _audioQueue = Queue<Uint8List>();
  bool _isPlaying = false;
  AudioPlayer? _currentPlayer;
  
  // Preload common phrases
  final List<String> _commonPhrases = [
    "Tap the Letter",
    "Tap the Color",
    "Tap the Shape",
    "Tap the Object",
    "Tap the Food",
    "Tap the Number",
    "Tap the Feeling",
    "Tap the Place",
    "Tap the Sight Word",
    "Tap the Action Verb",
    "Drag and Drop the Letter",
    "Drag and Drop the Color",
    "Drag and Drop the Shape",
    "Drag and Drop the Object",
    "Drag and Drop the Food",
    "Drag and Drop the Number",
    "Drag and Drop the Feeling",
    "Drag and Drop the Place",
    "Drag and Drop the Sight Word",
    "Drag and Drop the Action Verb",
    "Trace the Letter",
    "Trace the Shape",
    "Trace the Number",
  ];

  Future<void> init(String jsonKeyPath) async {
    if (_client != null) return;
    
    final jsonString = await rootBundle.loadString(jsonKeyPath);
    _credentials = ServiceAccountCredentials.fromJson(json.decode(jsonString));
    
    final scopes = ['https://www.googleapis.com/auth/cloud-platform'];
    _client = await clientViaServiceAccount(_credentials, scopes);
    
    // Preload common phrases
    await _preloadCommonPhrases();
  }

  Future<void> _preloadCommonPhrases() async {
    for (String phrase in _commonPhrases) {
      try {
        await _generateAndCacheAudio(phrase);
      } catch (e) {
        print("Failed to preload phrase '$phrase': $e");
      }
    }
  }

  String _getCacheKey(String text, String voiceName, String languageCode) {
    var bytes = utf8.encode('$text-$voiceName-$languageCode');
    return sha256.convert(bytes).toString();
  }

  Future<Uint8List> _generateAndCacheAudio(String text, {
    String languageCode = "en-US",
    String voiceName = "en-US-Standard-C",
    String audioEncoding = "MP3"
  }) async {
    if (_client == null) {
      throw Exception("GoogleTTS not initialized. Call init() first.");
    }

    final cacheKey = _getCacheKey(text, voiceName, languageCode);
    
    // Check cache first
    if (_audioCache.containsKey(cacheKey)) {
      return _audioCache[cacheKey]!;
    }

    final request = {
      "input": {"text": text},
      "voice": {"languageCode": languageCode, "name": voiceName},
      "audioConfig": {"audioEncoding": audioEncoding}
    };

    final response = await _client!.post(
      Uri.parse("https://texttospeech.googleapis.com/v1/text:synthesize"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(request),
    );

    if (response.statusCode != 200) {
      throw Exception("TTS failed: ${response.body}");
    }

    final audioContent = json.decode(response.body)['audioContent'];
    final bytes = Uint8List.fromList(base64Decode(audioContent));
    
    // Cache the audio with LRU eviction
    _cacheAudio(cacheKey, bytes);
    
    return bytes;
  }

  void _cacheAudio(String key, Uint8List audio) {
    if (_audioCache.length >= _maxCacheSize) {
      // Remove oldest entry (LRU)
      final oldestKey = _cacheKeys.removeFirst();
      _audioCache.remove(oldestKey);
    }
    
    _audioCache[key] = audio;
    _cacheKeys.add(key);
  }

  // Immediate playback - plays cached audio instantly or generates if needed
  Future<void> speak(String text, {
    String languageCode = "en-US",
    String voiceName = "en-US-Standard-C",
    bool skipQueue = false,
  }) async {
    try {
      final audioBytes = await _generateAndCacheAudio(
        text, 
        languageCode: languageCode, 
        voiceName: voiceName
      );
      
      if (skipQueue || !_isPlaying) {
        await _playAudioDirectly(audioBytes);
      } else {
        _audioQueue.add(audioBytes);
      }
    } catch (e) {
      print("TTS Error: $e");
      rethrow;
    }
  }

  // Queue multiple texts for sequential playback
  Future<void> speakQueue(List<String> texts, {
    String languageCode = "en-US",
    String voiceName = "en-US-Standard-C",
  }) async {
    for (String text in texts) {
      final audioBytes = await _generateAndCacheAudio(
        text, 
        languageCode: languageCode, 
        voiceName: voiceName
      );
      _audioQueue.add(audioBytes);
    }
    
    if (!_isPlaying) {
      _processAudioQueue();
    }
  }

  Future<void> _playAudioDirectly(Uint8List audioBytes) async {
    _currentPlayer?.stop();
    _currentPlayer = AudioPlayer();
    
    await _currentPlayer!.play(BytesSource(audioBytes));
    
    _currentPlayer!.onPlayerComplete.listen((_) {
      _currentPlayer = null;
      if (_audioQueue.isNotEmpty) {
        _processAudioQueue();
      } else {
        _isPlaying = false;
      }
    });
    
    _isPlaying = true;
  }

  Future<void> _processAudioQueue() async {
    if (_audioQueue.isEmpty || _isPlaying) return;
    
    final audioBytes = _audioQueue.removeFirst();
    await _playAudioDirectly(audioBytes);
  }

  // Preload text for later use (useful for anticipated speech)
  Future<void> preload(String text, {
    String languageCode = "en-US",
    String voiceName = "en-US-Standard-C",
  }) async {
    await _generateAndCacheAudio(text, languageCode: languageCode, voiceName: voiceName);
  }

  // Preload multiple texts in parallel
  Future<void> preloadBatch(List<String> texts, {
    String languageCode = "en-US",
    String voiceName = "en-US-Standard-C",
  }) async {
    final futures = texts.map((text) => 
      _generateAndCacheAudio(text, languageCode: languageCode, voiceName: voiceName)
    );
    await Future.wait(futures);
  }

  // Check if text is already cached
  bool isCached(String text, {
    String languageCode = "en-US", 
    String voiceName = "en-US-Standard-C"
  }) {
    final cacheKey = _getCacheKey(text, voiceName, languageCode);
    return _audioCache.containsKey(cacheKey);
  }

  // Stop current playback and clear queue
  Future<void> stop() async {
    await _currentPlayer?.stop();
    _currentPlayer = null;
    _audioQueue.clear();
    _isPlaying = false;
  }

  // Clear cache to free memory
  void clearCache() {
    _audioCache.clear();
    _cacheKeys.clear();
  }

  // Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'cached_items': _audioCache.length,
      'max_cache_size': _maxCacheSize,
      'queue_length': _audioQueue.length,
      'is_playing': _isPlaying,
    };
  }
}