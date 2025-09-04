import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SoundButton extends StatefulWidget {
  final String text;
  final Color desiredColor;
  final String audioAsset;

  const SoundButton({
    super.key,
    required this.text,
    required this.desiredColor,
    required this.audioAsset,
  });

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isHovered = false;
  bool _isPressed = false;

  Future<void> _playAudio() async {
    if (_audioPlayer.state == PlayerState.playing) return;
    await _audioPlayer.play(AssetSource(widget.audioAsset));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _isPressed
            ? 0.95
            : (_isHovered ? 1.05 : 1.0), // press = shrink, hover = enlarge
        curve: Curves.easeOut,
        child: Material(
          color: widget.desiredColor,
          borderRadius: BorderRadius.circular(8),
          elevation: _isHovered ? 6 : 2, // hover shadow
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _playAudio,
            onHighlightChanged: (isPressed) {
              setState(() => _isPressed = isPressed);
            },
            splashColor: Colors.white24, // ripple color
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.1,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              child: Text(
                widget.text,
                style: GoogleFonts.ubuntu(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
