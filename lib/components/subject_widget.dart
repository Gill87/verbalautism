import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectWidget extends StatelessWidget{

final Function()? tapFunction;
final String text;

const SubjectWidget({super.key, required this.tapFunction, required this.text});

  Widget build(BuildContext context){
    return GestureDetector(
      onTap: tapFunction,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
              image: const DecorationImage(image: AssetImage('lib/images/drake.jpg'), fit: BoxFit.cover),
            ),
                
                
            alignment: Alignment.bottomCenter,        
            child: Container(
              width: 150,
              color: Colors.white38.withOpacity(0.9),      
              child: Text(
                text,
                style: GoogleFonts.ubuntu(fontSize: 15, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    ); 
  }
}
