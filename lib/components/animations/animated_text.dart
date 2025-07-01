import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedText extends StatefulWidget {
  final String text;

  const AnimatedText({super.key, required this.text});

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {


  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      isRepeatingAnimation: false,
      animatedTexts: [
        TyperAnimatedText(
          widget.text,
          textStyle: GoogleFonts.ubuntu(fontSize: 40, color: Colors.white),
          speed: const Duration(milliseconds: 100)
        ),
      ],
    );
  }
}