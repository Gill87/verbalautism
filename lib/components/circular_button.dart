import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircularButton extends StatelessWidget {
  final String text;
  final Color color;

  const CircularButton({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        width: 75,
        height: 75,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.ubuntu(fontSize:17, color: Colors.white),
          ),
        ),
      ),
    );
  }
}