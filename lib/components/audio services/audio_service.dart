import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isMusicPlaying = true;

  bool get isMusicPlaying => _isMusicPlaying;

  Future<void> playBackgroundMusic() async {
    if (_isMusicPlaying) {
      try {
        await _player.setReleaseMode(ReleaseMode.loop);
        await _player.play(
          AssetSource("audio_files/background_music.mp3"),
          volume: 0.5,
        );
      } catch (e) {
        print('Error playing background music: $e');
      }
    }
  }

  Future<void> stopMusic() async {
    try {
      await _player.stop();
    } catch (e) {
      print('Error stopping music: $e');
    }
  }

  void toggleMusic() {
    _isMusicPlaying = !_isMusicPlaying;
    if (_isMusicPlaying) {
      playBackgroundMusic();
    } else {
      stopMusic();
    }
  }

  void setMusicEnabled(bool enabled) {
    _isMusicPlaying = enabled;
    if (!enabled) {
      stopMusic();
    }
  }

  void dispose() {
    _player.dispose();
  }
}