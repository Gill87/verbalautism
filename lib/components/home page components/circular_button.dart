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

  bool _isHovered = false;
  bool _isPressed = false;

  Future<void> _playAudio() async {
    // If something is already playing, do nothing
    final playerState = _audioPlayer.state;
    if (playerState == PlayerState.playing) {
      return; 
    }

    // Play the audio
    await _audioPlayer.play(AssetSource(widget.audioAsset));
  }

  // Calculate responsive button size based on screen height
  double _getButtonSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Define size breakpoints
    if (screenHeight <= 500) {
      return 50; // Very small screens
    } else if (screenHeight <= 600) {
      return 60; // Small screens
    } else if (screenHeight <= 700) {
      return 70; // Medium screens
    } else if (screenHeight <= 800) {
      return 75; // Default size
    } else {
      return 85; // Large screens
    }
  }

  // Calculate responsive font size
  double _getFontSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    if (screenHeight <= 500) {
      return 12;
    } else if (screenHeight <= 600) {
      return 14;
    } else if (screenHeight <= 700) {
      return 16;
    } else {
      return 17; // Default
    }
  }

  // Calculate responsive padding
  double _getPadding(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    if (screenHeight <= 500) {
      return 4;
    } else if (screenHeight <= 600) {
      return 6;
    } else {
      return 8; // Default
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = _getButtonSize(context);
    final fontSize = _getFontSize(context);
    final padding = _getPadding(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _playAudio();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: _isPressed ? 0.95 : (_isHovered ? 1.1 : 1.0), // press = shrink, hover = enlarge
          curve: Curves.easeOut,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(image: widget.image, fit: BoxFit.cover),                      
            ),
            child: Center(
              child: Text(
                widget.text,
                style: GoogleFonts.ubuntu(
                  fontSize: fontSize,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(1.5, 1.5),
                      blurRadius: 3,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}