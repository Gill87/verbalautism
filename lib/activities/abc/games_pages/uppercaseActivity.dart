// TAP Feature

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/correct_animation.dart';

class UppercaseActivity extends StatefulWidget {
  const UppercaseActivity({super.key});

  @override
  State<UppercaseActivity> createState() => _UppercaseActivityState();
}
  
class _UppercaseActivityState extends State<UppercaseActivity> {

  void _showCorrectAnimation() {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent, // Makes background transparent
          child: CorrectAnimation(),
        );
      },
    );

    // Close the animation after a short delay
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uppercase Letters"),
      ),
      
      body: Column(
        children: [
          Text(
            "Tap the Letter", 
            style: GoogleFonts.ubuntu(fontSize: 40)
          ),

          const SizedBox(height: 50),

          Center(
            child: GestureDetector(
              onTap: _showCorrectAnimation,
              child: Image(
                image: AssetImage("lib/images/abc_images/uppercaseB.png"),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                ),
            )
            ),
        ],
      )
    );
  }
}