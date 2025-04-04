// TAP Feature
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
import 'package:verbalautism/components/correct_animation.dart';

class TapComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String letterLink;

  const TapComponent({super.key, required this.onCompleted, required this.letterLink});

  @override
  State<TapComponent> createState() => _TapComponentState();
}
  
class _TapComponentState extends State<TapComponent> {

  void _showCorrectAnimation() {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return const Center(
          child: CorrectAnimation(),
        );
      },
    );

    // Close the animation after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onCompleted();
        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.4,
      
      child: Column(
        children: [
          Text(
            "Tap the Letter", 
            style: GoogleFonts.ubuntu(fontSize: 40)
          ),
      
          const SizedBox(height: 50),
      
          Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _showCorrectAnimation,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image(
                      image: AssetImage("lib/images/abc_images/${widget.letterLink}.png"),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.fill,
                    ),
                    
                    // Lottie Animation
                    // Positioned.fill(
                    //   child: Lottie.network(
                    //     "https://lottie.host/b4a90af8-4e69-4372-9146-60eb855bb0ba/ySCUk4ATJ6.json",
                    //     fit: BoxFit.contain,
                    //     repeat: true,
                    //   ),
                    // ),
                  ]
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}