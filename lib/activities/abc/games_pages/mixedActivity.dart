// DRAG AND DROP Feature

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/correct_animation.dart';

class MixedActivity extends StatefulWidget {
  const MixedActivity({super.key});

  @override
  State<MixedActivity> createState() => _MixedActivityState();
}

class _MixedActivityState extends State<MixedActivity> {

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
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mixed Letters"),
      ),

      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Draggable Image
            Draggable<String> (
              data: "image",
              feedback: Material(
                child: Transform.translate(
                  offset: const Offset(100, 0),
                  child: Image.asset(
                    'lib/images/abc_images/uppercaseB.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),

              // Original image dims when dragging
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'lib/images/abc_images/uppercaseB.png',
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.4
                ),
              ),

              // When not dragging and image has not been dropped, display static image
              child: imageDropped
              ? Text("")
              : Image.asset(
                "lib/images/abc_images/uppercaseB.png",
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.4
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
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(color: Colors.blueGrey),
                  child: imageDropped 
                    ? Image.asset('lib/images/abc_images/uppercaseB.png')
                    : Center(child: Text("Drop Here", style: GoogleFonts.ubuntu(fontSize: 30),))
                );
              }
            ),
        
          ],
        ),
      ),
    );
  }
}