import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameLoadingIndicator extends StatelessWidget {
  final String titleHeader;

  const GameLoadingIndicator({
    required this.titleHeader,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          titleHeader, 
          style: GoogleFonts.ubuntu(
            fontSize:24, 
            fontWeight: FontWeight.bold, 
            color: Colors.white
          )
        ),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_images/colorful_bg.webp"),
            fit: BoxFit.cover,
          )
        ),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
    );  
  }
}