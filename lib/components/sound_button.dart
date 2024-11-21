import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SoundButton extends StatelessWidget {

  final Function()? tapFunction;
  final String text;
  final Color desiredColor;

  const SoundButton({super.key, required this.tapFunction, required this.text, required this.desiredColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapFunction,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: desiredColor,
            borderRadius: BorderRadius.circular(8),
            ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.ubuntu(fontSize: 24, color: Colors.white),
              ),
          )
        ),
      ),
    );
  }
}