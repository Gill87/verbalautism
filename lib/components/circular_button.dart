import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircularButton extends StatefulWidget {
  final String text;
  final AssetImage image;
  final String audioAsset;

  const CircularButton({super.key, required this.text, required this.image, required this.audioAsset});

  @override
  State<CircularButton> createState() => _CircularButtonState();
}

class _CircularButtonState extends State<CircularButton> {

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
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _playAudio,
        child: Container(
          width: 75,
          height: 75,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: DecorationImage(image: widget.image, fit: BoxFit.cover),
            
          ),
          child: Center(
            child: Text(
              widget.text,
              style: GoogleFonts.ubuntu(
                fontSize:17, 
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: const Offset(1.5, 1.5),
                    blurRadius: 3,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}