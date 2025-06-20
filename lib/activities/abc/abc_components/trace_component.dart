// TRACE FEATURE
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracing_game/tracing_game.dart';
import 'package:verbalautism/components/correct_animation.dart';

class TraceComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String letter;

  const TraceComponent({super.key, required this.onCompleted, required this.letter});

  @override
  State<TraceComponent> createState() => _TraceComponentState();
}

class _TraceComponentState extends State<TraceComponent> {
  
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
    return Column(
      children: [
        Text(
          "Trace the Letter ${widget.letter}", 
          style: GoogleFonts.ubuntu(fontSize: 40, color: Colors.white)
        ),        
        
        const SizedBox(height: 50),

        Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.4,
          child: TracingCharsGame(
            traceShapeModel: [
              TraceCharsModel(
                chars: [
                  TraceCharModel(
                    char: widget.letter,
                    traceShapeOptions: const TraceShapeOptions(innerPaintColor: Color.fromARGB(255, 33, 150, 243))
                  )
                ]
              )
            ],
            onGameFinished: (int index) async {
              _showCorrectAnimation();
            },
          )
        ),
      ],
    );
  }
}