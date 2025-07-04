// TRACE FEATURE
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracing_game/tracing_game.dart';
import 'package:verbalautism/components/animations/correct_animation.dart';
import 'package:verbalautism/components/tts_service.dart';

class TraceComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String mainData;
  final VoidCallback onCorrectAction;
  final String objectVariation;

  const TraceComponent({
    super.key, 
    required this.onCompleted, 
    required this.mainData, 
    required this.onCorrectAction,
    required this.objectVariation,
  });

  @override
  State<TraceComponent> createState() => _TraceComponentState();
}

class _TraceComponentState extends State<TraceComponent> {

  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    _ttsService.speak("Trace the ${widget.objectVariation} ${widget.mainData}");
    super.initState();
  }
  
  void _showCorrectAnimation(){

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

  bool isChar(){
    if(widget.mainData.length == 1){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Text(
          "Trace the ${widget.objectVariation} ${widget.mainData}", 
          style: GoogleFonts.ubuntu(
            fontSize: screenWidth <= 660 ? 30 : 40, 
            color: Colors.white
          ),
        ),
        
        const SizedBox(height: 50),

        Container(
          color: Colors.transparent,
          width: screenWidth * 0.5,
          height: screenHeight * 0.4,
          child: isChar() 
            ? TracingCharsGame(
              traceShapeModel: [
                TraceCharsModel(
                  chars: [
                    TraceCharModel(
                      char: widget.mainData,
                      traceShapeOptions: const TraceShapeOptions(innerPaintColor: Color.fromARGB(255, 33, 150, 243))
                    )
                  ]
                )
              ],
              onGameFinished: (int index) async {
                _showCorrectAnimation();
              },
            )
            : TracingWordGame(
              words: [
                TraceWordModel(
                  word: widget.mainData,
                  traceShapeOptions: const TraceShapeOptions(innerPaintColor: Color.fromARGB(255, 33, 150, 243))
                )
              ],
              onGameFinished: (int index) async {
                _showCorrectAnimation();
              },
            ),

        )
      ],
    );
  }
}