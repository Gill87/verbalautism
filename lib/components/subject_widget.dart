import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectWidget extends StatelessWidget{

final Function()? tapFunction;
final String text;
final AssetImage image1;
final double height;
final double width;
final Color color;

const SubjectWidget({super.key, required this.tapFunction, required this.text, required this.image1, this.width = 100, this.height = 10, this.color = Colors.black});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: tapFunction,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
              image: DecorationImage(image: image1, fit: BoxFit.cover),
              border: Border.all(width: 1)
            ),
                
                
            alignment: Alignment.bottomCenter,        
            child: Container(
              width: width,
              color: Colors.white38.withOpacity(0.9),      
              child: Text(
                text,
                style: GoogleFonts.ubuntu(
                  fontSize: 15, 
                  color: Colors.black
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    ); 
  }
}
