import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/animations/correct_animation.dart';
import 'package:verbalautism/components/animations/incorrect_animation.dart';
import 'package:verbalautism/components/tts_service.dart';

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
    if (tappedLetter == widget.correctAssetLink) {
      _showCorrectAnimation();
    } else {
      _showIncorrectAnimation();
    }
  }

  void _showIncorrectAnimation(){

    widget.onIncorrectAction();

    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return const Center(
          child: IncorrectAnimation(),
        );
      }
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
    
  }

  void _showCorrectAnimation() {

    widget.onCorrectAction();
    
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

  bool isColor() {
    if (widget.objectVariation == "Color") {
      return true;
    } else {
      return false;
    }
  }

  bool isTooLarge() {
    if (widget.objectVariation == "Feeling" || widget.objectVariation == "Object" || widget.objectVariation == "Food" || widget.objectVariation == "Place") {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
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

    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.8,
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
                padding: EdgeInsets.symmetric(horizontal: isTooLarge() ? 25 : 15),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _handleTap(object),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.3,
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
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.3,
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
                          child: Transform.scale(
                              scale: 1.5,
                              child: !isColor()
                              ? SvgPicture.asset(
                                '${widget.directory}$object.svg',
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.height * 0.25,
                                fit: BoxFit.contain,
                              )
                              : Padding(      // Only for Colors Tap
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.1,
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      color: colorMap[object.toLowerCase()],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
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
