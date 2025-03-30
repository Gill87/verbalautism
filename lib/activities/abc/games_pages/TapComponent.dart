// TAP Feature
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
      context: context,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent, // Makes background transparent
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
    return Column(
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
                  // Lottie Animation
                  Positioned.fill(
                    child: Lottie.network(
                      "https://lottie.host/858e5f4b-fd2f-4c4a-a658-4d5e42322a35/t6de2GaCSm.json",
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                  Image(
                    image: AssetImage("lib/images/abc_images/${widget.letterLink}.png"),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),

                ]
              ),
            ),
          )
        ),
      ],
    );
  }
}