// DRAG AND DROP Feature

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
import 'package:verbalautism/components/correct_animation.dart';

class DragDropComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String letterLink;

  const DragDropComponent({super.key, required this.onCompleted, required this.letterLink});

  @override
  State<DragDropComponent> createState() => _DragDropComponentState();
}

class _DragDropComponentState extends State<DragDropComponent> {

  bool imageDropped = false;
  
  void _showCorrectAnimation(){
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
          "Drag and Drop the Letter", 
          style: GoogleFonts.ubuntu(fontSize: 40)
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
                child: Transform.translate(
                  offset: const Offset(200, 0),
                  child: Image.asset(
                    'lib/images/abc_images/${widget.letterLink}.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
        
              // Original image dims when dragging
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'lib/images/abc_images/${widget.letterLink}.png',
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.4
                ),
              ),
        
              // When not dragging and image has not been dropped, display static image
              child: imageDropped
              ? const Text("")
              : Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'lib/images/abc_images/${widget.letterLink}.png',
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.4
                  ),
                  
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
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: const BoxDecoration(color: Colors.lightBlue),
                  child: imageDropped 
                    ? Image.asset('lib/images/abc_images/${widget.letterLink}.png',)
                    : Center(child: Text("Drop Here", style: GoogleFonts.ubuntu(fontSize: 30),))
                );
              }
            ),
            
          ],
        ),
      ],
    );
  }
}