// TAP Feature
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/animations/correct_animation.dart';
import 'package:verbalautism/components/animations/tap_animation.dart';
import 'package:verbalautism/components/tts_service.dart';

class TapComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String letterLink;
  final String letter;
  final VoidCallback onCorrectAction;
  final int totalSteps;
  final String directory;
  final String objectVariation;

  const TapComponent({super.key, required this.onCompleted, required this.letterLink, required this.letter, required this.onCorrectAction, required this.totalSteps, required this.directory, required this.objectVariation});

  @override
  State<TapComponent> createState() => _TapComponentState();
}
  
class _TapComponentState extends State<TapComponent> with SingleTickerProviderStateMixin {
  bool tapClicked = false;
  bool showTapAnimation = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    
    // Text to speech
    _ttsService.speak("Tap the ${widget.objectVariation} ${widget.letter}");

    // Floating Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true); // makes it float up and down

    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (mounted && !tapClicked) {
      setState(() {
        showTapAnimation = true;
      });
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    _ttsService.stop();
    super.dispose();
  }

  void _showCorrectAnimation() {
    tapClicked = true;

    setState(() {
      showTapAnimation = false;
    });

    _controller.stop();  // stop floating

    widget.onCorrectAction();  // <-- trigger the flash!

    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return const Center(
          child: CorrectAnimation(),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.transparent,
      width: screenWidth * 0.5,

      child: Column(
        children: [
          Text(
            "Tap the ${widget.objectVariation} ${widget.letter}",
            style: GoogleFonts.ubuntu(
              fontSize: screenWidth <= 700 ? 32 : 40, 
              color: Colors.white
            ),
          ),

          // AnimatedText(text: "Tap the Letter ${widget.letter}"),

          const SizedBox(height: 50),

          Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _showCorrectAnimation,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -_animation.value),
                          child: Transform.scale(
                            scale: 1.5,
                            child: child,
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        '${widget.directory}${widget.letterLink}.svg',
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.4,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Optionally show tap animation
                    if (showTapAnimation && !tapClicked && widget.totalSteps == 1)
                      const TapAnimation(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
