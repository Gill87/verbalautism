// DRAG AND DROP Feature

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/correct_animation.dart';
import 'package:verbalautism/components/drag_animation.dart';
import 'package:verbalautism/components/tts_service.dart';

class DragDropComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String letterLink;
  final String letter;
  final VoidCallback onCorrectAction;
  final int totalSteps;
  
  const DragDropComponent({super.key, required this.onCompleted, required this.letterLink, required this.letter, required this.onCorrectAction, required this.totalSteps});

  @override
  State<DragDropComponent> createState() => _DragDropComponentState();
}

class _DragDropComponentState extends State<DragDropComponent> with SingleTickerProviderStateMixin {

  bool imageDropped = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _ttsService.speak("Drag and Drop the Letter ${widget.letter}");
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true); // makes it float up and down

    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

  }
  
  void _showCorrectAnimation(){
    
    // Flash Green
    widget.onCorrectAction();

    showDialog(
      barrierColor: Colors.transparent,
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
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          Text(
            "Drag and Drop the Letter ${widget.letter}", 
            style: GoogleFonts.ubuntu(fontSize: 40, color: Colors.white)
          ),
      
          const SizedBox(height: 50),
      
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Draggable Image
              Draggable<String> (
                data: "image",
                feedback: Opacity(
                  opacity: 1,
                  child: Stack(
                    children: [
                      Transform.scale(
                        scale: 1.5,
                        child: SvgPicture.asset(
                          'assets/abc_images/${widget.letterLink}.svg',
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.4,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
          
                // Original image disappers dragging
                childWhenDragging: Opacity(
                  opacity: 0.0,
                  child: SvgPicture.asset(
                    'assets/abc_images/${widget.letterLink}.svg',
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.4,
                    fit: BoxFit.contain,
                  ),
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
                              scale: 1,
                              child: child
                            ),
                          );
                        },

                        // Image
                        child: SvgPicture.asset(
                          'assets/abc_images/${widget.letterLink}.svg',
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.4,
                          fit: BoxFit.contain,
                        )
                      ),
                      
                      // Drag Animation (centered by Stack's alignment) if first one
                      if(widget.totalSteps == 2)
                        const DragAnimation(),
                    ],
                  )
                  : const SizedBox.shrink()

              ),
          
              const SizedBox(width: 50),
          
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
                            ? SvgPicture.asset(
                                'assets/abc_images/${widget.letterLink}.svg',
                                key: const ValueKey('droppedImage'),
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height * 0.4,
                                fit: BoxFit.contain,
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