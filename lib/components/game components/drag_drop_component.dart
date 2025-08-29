// DRAG AND DROP Feature

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/animations/correct_animation.dart';
import 'package:verbalautism/components/animations/drag_animation.dart';
import 'package:verbalautism/components/audio%20services/tts_service.dart';

class DragDropComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String assetLink;
  final String mainData; // This is the object
  final VoidCallback onCorrectAction;
  final int totalSteps;
  final String directory;
  final String objectVariation;
  
  const DragDropComponent({
    super.key, 
    required this.onCompleted, 
    required this.assetLink, 
    required this.mainData, 
    required this.onCorrectAction, 
    required this.totalSteps,
    required this.directory,
    required this.objectVariation,
  });

  @override
  State<DragDropComponent> createState() => _DragDropComponentState();
}

class _DragDropComponentState extends State<DragDropComponent> with SingleTickerProviderStateMixin {

  bool imageDropped = false;
  bool isProcessing = false;


  late AnimationController _controller;
  late Animation<double> _animation;

  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _ttsService.speak("Drag and Drop the ${widget.objectVariation} ${widget.mainData}");

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true); // makes it float up and down

    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

  }
  
  void _showCorrectAnimation(){
    // NEW: Prevent multiple calls
    if (isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });

    // Flash Green
    widget.onCorrectAction();

    showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false, // NEW: Prevent dismissing dialog by tapping
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
      if (mounted && isProcessing) { // NEW: Additional safety check
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
    if(widget.objectVariation == "Feeling" || widget.objectVariation == "Object" || widget.objectVariation == "Food" || widget.objectVariation == "Place" || widget.objectVariation == "Sight Word"){
      return true;
    } else {
      return false;
    }
  }

  bool isShape(){
    if(widget.objectVariation == "Shape"){
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    _controller.dispose();
    _animation.removeListener(() {}); // Remove listener to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final double screenWidth = MediaQuery.of(context).size.width;

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
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          Text(
            "Drag and Drop the ${widget.objectVariation} ${widget.mainData}", 
            style: GoogleFonts.ubuntu(
              fontSize: screenWidth < 650 ? 35 : 40,
              color: Colors.white,
            ),
          ),
      
          const SizedBox(height: 50),
      
          Row(
            mainAxisAlignment: !imageDropped ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
            children: [
              // Draggable Image
              Draggable<String> (
                data: "image",
                feedback: Opacity(
                  opacity: 1,
                  child: Stack(
                    children: [
                      Transform.scale(
                        scale: isTooLarge() ? 1.0 : 1.5,
                        child: !emptyAssetLink()
                          ? SvgPicture.asset(
                            '${widget.directory}${widget.assetLink}.svg',
                            width: isShape()
                              ? MediaQuery.of(context).size.width * 0.3
                              : MediaQuery.of(context).size.width * 0.4,
                            height: isShape()
                              ? MediaQuery.of(context).size.height * 0.3
                              : MediaQuery.of(context).size.height * 0.4,
                            fit: BoxFit.contain,
                          )
                          : Padding( // Only for Colors Drag Drop
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
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
                            )
                        ),
                    ],
                  ),
                ),
          
                // Original image disappers dragging
                childWhenDragging: Opacity(
                  opacity: 0.0,
                  child: !emptyAssetLink()
                    ? SvgPicture.asset(
                      '${widget.directory}${widget.assetLink}.svg',
                      width: isShape()
                        ? MediaQuery.of(context).size.width * 0.3
                        : MediaQuery.of(context).size.width * 0.4,
                      height: isShape()
                        ? MediaQuery.of(context).size.height * 0.3
                        : MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.contain,
                    )
                    : Padding( // Only for Colors Drag Drop
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
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
                      )
                ),
                
                // When not dragging, static image displayed with floating animation
                child: !imageDropped 
                  ? Stack(
                    alignment: Alignment.center,  // ✅ Center everything in the stack
                    children: [

                      AnimatedBuilder(
                        animation: _animation, 
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_animation.value),
                            child: Transform.scale(
                              scale: isTooLarge() ? 0.75 : 1,
                              child: child
                            ),
                          );
                        },

                        // Image
                        child: !emptyAssetLink()
                          ? SvgPicture.asset(
                            '${widget.directory}${widget.assetLink}.svg',
                            width: isShape()
                              ? MediaQuery.of(context).size.width * 0.3
                              : MediaQuery.of(context).size.width * 0.4,
                            height: isShape()
                              ? MediaQuery.of(context).size.height * 0.3
                              : MediaQuery.of(context).size.height * 0.4,
                            fit: BoxFit.contain,
                          )
                          : Padding( // Only for Colors Drag Drop
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
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
                            )
                      ),
                      
                      // Drag Animation (centered by Stack's alignment) if first one
                      if(widget.totalSteps == 2)
                        const DragAnimation(),
                    ],
                  )
                  : const SizedBox.shrink()

              ),
          
              // const SizedBox(width: 50),
          
              // Drag Target
              AnimatedAlign(
                alignment: imageDropped ? Alignment.center : Alignment.centerRight,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: DragTarget<String>(
                  onAcceptWithDetails: (data) {
                    setState(() {
                      imageDropped = true;
                    });

                    Future.delayed(const Duration(milliseconds: 500), () {
                      _showCorrectAnimation();
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, -1.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: imageDropped
                            ? !emptyAssetLink()
                              ? SvgPicture.asset(
                                '${widget.directory}${widget.assetLink}.svg',
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.4,
                                fit: BoxFit.contain,
                              )
                              : Padding( // Only for Colors Drag Drop
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
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
                                )
                            : Center(
                                key: const ValueKey('dropText'),
                                child: Text(
                                  "Drop Here",
                                  style: GoogleFonts.ubuntu(fontSize: 30),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}