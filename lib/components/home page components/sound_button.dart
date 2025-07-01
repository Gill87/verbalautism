import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SoundButton extends StatefulWidget {

  final String text;
  final Color desiredColor;
  final String audioAsset;

  const SoundButton({super.key, required this.text, required this.desiredColor, required this.audioAsset});

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playAudio() async {
    
    // If something is already playing, do nothing
    final playerState = _audioPlayer.state;
    if (playerState == PlayerState.playing) {
      return; 
    }

    // Play the audio
    await _audioPlayer.play(AssetSource(widget.audioAsset));  
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playAudio,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height * 0.1,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: widget.desiredColor,
            borderRadius: BorderRadius.circular(8),
            ),
          child: Center(
            child: Text(
              widget.text,
              style: GoogleFonts.ubuntu(fontSize: 24, color: Colors.white),
              ),
          )
        ),
      ),
    );
  }
}