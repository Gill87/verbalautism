import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallButton extends StatelessWidget {

  final Function()? tapFunction;
  final String text;

  const SmallButton({super.key, required this.tapFunction, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapFunction,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color:Colors.black,
          borderRadius: BorderRadius.circular(8),
          ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.white),
            ),
        )
      ),
    );
  }
}