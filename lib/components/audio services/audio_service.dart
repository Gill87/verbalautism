import 'package:audioplayers/audioplayers.dart';
import 'package:verbalautism/components/audio%20services/audio_cubit.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();
  AudioCubit audioCubit = AudioCubit();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playBackgroundMusic() async {
    if(audioCubit.state.isMusicPlaying){
      await _player.setReleaseMode(ReleaseMode.loop); // loop forever
      await _player.play(
        AssetSource("audio_files/background_music.mp3"), // put your file in assets/music/
        volume: 0.5,
      );
    }
  }

  Future<void> stopMusic() async {
    await _player.stop();
  }

  // Future<void> pauseMusic() async {
  //   await _player.pause();
  // }

  // Future<void> resumeMusic() async {
  //   await _player.resume();
  // }
}
