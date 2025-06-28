import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleButton extends StatelessWidget {

  final Function()? tapFunction;

  const ScheduleButton({super.key, required this.tapFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapFunction,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 100,
          height: 50,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.yellow[800],
            borderRadius: BorderRadius.circular(15),
            ),
          child: Center(
            child: Text(
              'Schedule',
              style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.white),
              ),
          )
        ),
      ),
    );  
  }
}