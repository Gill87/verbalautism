import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LargeSubjectWidget extends StatelessWidget {

    
  final Function()? tapFunction;
  final String text;
  final AssetImage image1;

  const LargeSubjectWidget({
    super.key,
    required this.tapFunction,
    required this.text,
    required this.image1,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapFunction,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
                image: DecorationImage(image: image1, fit: BoxFit.fitWidth),
                border: Border.all(width: 1)
              ),
                  
                  
              alignment: Alignment.bottomCenter,        
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                color: Colors.white38.withOpacity(0.9),      
                child: Text(
                  text,
                  style: GoogleFonts.ubuntu(fontSize: 30, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );   
  }
}