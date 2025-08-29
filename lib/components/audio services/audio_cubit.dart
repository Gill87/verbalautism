import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbalautism/components/audio%20services/audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioState(isMusicPlaying: true));

  void toggleMusic() {
    emit(AudioState(isMusicPlaying: !state.isMusicPlaying));
  }
}