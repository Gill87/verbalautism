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
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height * 0.1,
          padding: const EdgeInsets.all(5),
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