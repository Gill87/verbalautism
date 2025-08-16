// TAP Feature
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/animations/correct_animation.dart';
import 'package:verbalautism/components/animations/tap_animation.dart';
import 'package:verbalautism/components/tts_service.dart';

class TapComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String assetLink;
  final String mainData;
  final VoidCallback onCorrectAction;
  final int totalSteps;
  final String directory;
  final String objectVariation;

  const TapComponent({super.key, required this.onCompleted, required this.assetLink, required this.mainData, required this.onCorrectAction, required this.totalSteps, required this.directory, required this.objectVariation});

  @override
  State<TapComponent> createState() => _TapComponentState();
}
  
class _TapComponentState extends State<TapComponent> with SingleTickerProviderStateMixin {
  bool tapClicked = false;
  bool showTapAnimation = false;
  bool isProcessing = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    
    // Text to speech
    _ttsService.speak("Tap the ${widget.objectVariation} ${widget.mainData}");

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
    _animation.removeListener(() {});
    _ttsService.stop();
    super.dispose();
  }

  void _showCorrectAnimation() {
    // ENHANCED: Check both tapClicked AND isProcessing
    if(tapClicked || isProcessing) return;
    
    setState(() {
      tapClicked = true;
      isProcessing = true; // NEW: Set processing flag
      showTapAnimation = false;
    });

    _controller.stop();  // stop floating

    widget.onCorrectAction();  // <-- trigger the flash!

    showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false, // NEW: Prevent dismissing dialog by tapping
      context: context,
      builder: (context) {
        return const Center(
          child: CorrectAnimation(),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && isProcessing) { // NEW: Additional check
        Navigator.of(context).pop();
        setState(() {
          isProcessing = false; // NEW: Reset processing flag
        });
        widget.onCompleted();
      }
    });
  }

  bool emptyAssetLink(){
    if (widget.assetLink.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool isTooLarge(){
    if(widget.objectVariation == "Sight Word"){
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    Map<String, Color> colorMap = {};

    if(widget.objectVariation == "Color"){
      colorMap = {
        'blue': Colors.blue,
        'red': Colors.red,
        'green': Colors.green,
        'black': Colors.black,
        'white': Colors.white,
        'yellow': Colors.yellow,
        'purple': Colors.purple,
        'orange': Colors.orange,
        'pink': Colors.pink,
        'brown': Colors.brown,
      };
    }

    return Container(
      color: Colors.transparent,
      width: screenWidth * 0.5,

      child: Column(
        children: [
          Text(
            "Tap the ${widget.objectVariation} ${widget.mainData}",
            style: GoogleFonts.ubuntu(
              fontSize: screenWidth <= 700 ? 32 : 40, 
              color: Colors.white
            ),
          ),

          // AnimatedText(text: "Tap the ${widget.objectVariation} ${widget.mainData}"),

          const SizedBox(height: 50),

          Center(
            child: GestureDetector(
              onTap: _showCorrectAnimation,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
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
                      child: !emptyAssetLink()
                      ? SvgPicture.asset( 
                        '${widget.directory}${widget.assetLink}.svg',
                        width:  isTooLarge() 
                        ? MediaQuery.of(context).size.width * 0.2 
                        : MediaQuery.of(context).size.width * 0.25,
                        height: isTooLarge()
                        ? MediaQuery.of(context).size.height * 0.2
                        : MediaQuery.of(context).size.height * 0.25,
                        fit: BoxFit.contain,
                      ) 
                      : Padding(      // Only for Colors Tap
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            color: colorMap[widget.mainData.toLowerCase()],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
