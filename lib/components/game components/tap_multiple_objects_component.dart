import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/animations/correct_animation.dart';
import 'package:verbalautism/components/animations/incorrect_animation.dart';
import 'package:verbalautism/components/audio%20services/tts_service.dart';

class TapMultipleObjectsComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String correctAssetLink;
  final List<String> wrongAssetLinks; // 1 or 2 wrong objects
  final String mainData; // This is the object
  final VoidCallback onCorrectAction;
  final VoidCallback onIncorrectAction;
  final String directory;
  final String objectVariation;

  const TapMultipleObjectsComponent({
    super.key,
    required this.onCompleted,
    required this.correctAssetLink,
    required this.wrongAssetLinks,
    required this.mainData,
    required this.onCorrectAction,
    required this.onIncorrectAction,
    required this.directory,
    required this.objectVariation,
  });

  @override
  State<TapMultipleObjectsComponent> createState() => _TapMultipleObjectsComponentState();
}

class _TapMultipleObjectsComponentState extends State<TapMultipleObjectsComponent> with SingleTickerProviderStateMixin{
  late List<String> allObjectLinks;
  late AnimationController _controller;
  late Animation<double> _animation;

  final TtsService _ttsService = TtsService();
  
  bool isProcessing = false; // NEW: Prevent interactions during processing

  @override
  void initState() {
    super.initState();
    
    _ttsService.speak("Tap the ${widget.objectVariation} ${widget.mainData}");

    allObjectLinks = [widget.correctAssetLink, ...widget.wrongAssetLinks];
    allObjectLinks.shuffle(); // Randomize their order

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true); // makes it float up and down

    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _handleTap(String tappedLetter) {
    // NEW: Prevent handling taps when processing
    if (isProcessing) return;
    
    if (tappedLetter == widget.correctAssetLink) {
      _showCorrectAnimation();
    } else {
      _showIncorrectAnimation();
    }
  }

  void _showIncorrectAnimation(){
    // NEW: Prevent multiple calls
    if (isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });

    widget.onIncorrectAction();

    showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false, // NEW: Prevent dismissing dialog by tapping
      context: context,
      builder: (context) {
        return const Center(
          child: IncorrectAnimation(),
        );
      }
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && isProcessing) { // NEW: Additional safety check
        Navigator.of(context).pop();
        setState(() {
          isProcessing = false; // NEW: Reset processing flag
        });
        // NEW: Don't call onCompleted for incorrect answers, just reset processing
        widget.onCompleted();
      }
    });
  }


  void _showCorrectAnimation() {
    // NEW: Prevent multiple calls
    if (isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });

    widget.onCorrectAction();
    
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
      if (mounted && isProcessing) { // NEW: Additional safety check
        Navigator.of(context).pop();
        setState(() {
          isProcessing = false; // NEW: Reset processing flag
        });
        widget.onCompleted();
      }
    });
  }

  bool isColor() {
    if (widget.objectVariation == "Color") {
      return true;
    } else {
      return false;
    }
  }

  // bool isTooLarge() {
  //   if (widget.objectVariation == "Feeling" || widget.objectVariation == "Object" || widget.objectVariation == "Food" || widget.objectVariation == "Place") {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  @override
  void dispose() {
    _ttsService.stop();
    _controller.dispose();
    _animation.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.transparent,
      width: screenWidth * 0.85,
      child: Column(
        children: [
          Text(
            "Tap the ${widget.objectVariation} ${widget.mainData}",
            style: GoogleFonts.ubuntu(fontSize: 40, color: Colors.white),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: allObjectLinks.map((object) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.075),
                child: MouseRegion(
                    // NEW: Change cursor when processing
                    cursor: isProcessing ? SystemMouseCursors.basic : SystemMouseCursors.click, 

                    child: GestureDetector(
                    // NEW: Disable tap when processing
                    onTap: isProcessing ? null : () => _handleTap(object),                    
                    child: Container(
                      width: (allObjectLinks.length > 2) ? screenWidth * 0.1 : screenWidth * 0.2,
                      height: (allObjectLinks.length > 2) ? screenHeight * 0.2 : screenHeight * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.1),
                        //     blurRadius: 4,
                        //     offset: const Offset(0, 4),
                        //   ),
                        // ],
                      ),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _animation.value),
                          child: child,
                        );
                      },
                      child: Container(
                        width: screenWidth * 0.2,
                        height: screenHeight * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.1),
                          //     blurRadius: 8,
                          //     offset: const Offset(0, 4),
                          //   ),
                          // ],
                        ),
                        child: Center(
                          child: !isColor()
                          ? SizedBox(
                            child: SvgPicture.asset(
                              '${widget.directory}$object.svg',
                              width: screenWidth * 0.15 * 1.5,
                              height: screenHeight * 0.25 * 1.5,
                              fit: BoxFit.contain,
                            ),
                          )
                          : Padding(      // Only for Colors Tap
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: screenWidth * 0.1,
                                height: screenHeight * 0.2,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  color: colorMap[object.toLowerCase()],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                          )
                          ),
                      ),
                    )
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    ),
  );
}}
