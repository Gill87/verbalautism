// DRAG AND DROP Feature

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/correct_animation.dart';

class DragDropComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String letterLink;
  final String letter;
  
  const DragDropComponent({super.key, required this.onCompleted, required this.letterLink, required this.letter});

  @override
  State<DragDropComponent> createState() => _DragDropComponentState();
}

class _DragDropComponentState extends State<DragDropComponent> {

  bool imageDropped = false;
  
  void _showCorrectAnimation(){
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
                      SvgPicture.asset(
                        'assets/abc_images/${widget.letterLink}.svg',
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.4,
                        fit: BoxFit.contain,
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
                
                // When not dragging, static image displayed
                child: !imageDropped 
                  ? SvgPicture.asset(
                    'assets/abc_images/${widget.letterLink}.svg',
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.4,
                    fit: BoxFit.contain,
                  )
                  : const SizedBox.shrink(),
          
              ),
          
              const SizedBox(width: 50),
          
              // Drag Target
              DragTarget<String> (
                onAcceptWithDetails: (data) {
                  setState(() {
                    // Update dropped status if data is dropped in
                    imageDropped = true;
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
                    child: imageDropped 
                      ? SvgPicture.asset(
                        'assets/abc_images/${widget.letterLink}.svg',
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.4,
                        fit: BoxFit.contain,
                      )
                      : Center(child: Text("Drop Here", style: GoogleFonts.ubuntu(fontSize: 30),))
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}