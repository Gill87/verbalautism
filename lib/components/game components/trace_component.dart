// TRACE FEATURE
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracing_game/tracing_game.dart';
import 'package:verbalautism/components/animations/correct_animation.dart';
import 'package:verbalautism/components/audio%20services/tts_service.dart';

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
  bool isProcessing = false; // Prevent multiple interactions
  bool traceCompleted = false; // NEW: Track if tracing is completed

  Map<String, MathShapes> shapesMap = {};


  @override
  void initState() {

    // Check Mixed Letter
    if(isMixedLetter()){
      _ttsService.speak("Trace the ${widget.objectVariation} ${widget.mainData[0]}");
    } else {
      _ttsService.speak("Trace the ${widget.objectVariation} ${widget.mainData}");
    }
    
    super.initState();
  }
  
  void _showCorrectAnimation(){
    // ENHANCED: Check both isProcessing and traceCompleted
    if(isProcessing || traceCompleted) return;

    setState(() {
      isProcessing = true;
      traceCompleted = true; // NEW: Mark trace as completed
    });

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
      if (mounted && isProcessing) { // Additional safety check
        Navigator.of(context).pop();
        setState(() {
          isProcessing = false; // Reset processing flag
        });
        widget.onCompleted();
      }
    });
  }

  // NEW: Safe callback wrapper to prevent multiple calls
  Future <void> _onTraceFinished(int index) async {
    if (!isProcessing && !traceCompleted) {
      _showCorrectAnimation();
    }
  }

  @override
  void dispose(){
    _ttsService.stop();
    super.dispose();
  }

  bool isChar(){
    if(widget.mainData.length == 1){
      return true;
    }
    return false;
  }

  bool isMixedLetter(){
    if(widget.objectVariation == "Letter" && widget.mainData.length > 1){
      return true;
    } else {
      return false;
    }
  }

  bool isShape(){
    if(widget.objectVariation == "Shape"){
      shapesMap = {
        'circle': MathShapes.circle,
        'triangle': MathShapes.triangle1,
        'rectangle': MathShapes.rectangle,
      };
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Text(
          "Trace the ${widget.objectVariation} ${isMixedLetter() ? widget.mainData[0] : widget.mainData}", 
          style: GoogleFonts.ubuntu(
            fontSize: screenWidth <= 660 ? 30 : 40, 
            color: Colors.white
          ),
        ),
        
        const SizedBox(height: 50),

        IgnorePointer(
          ignoring: isProcessing, // Prevent interaction during processing
          child: Container(
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
                onGameFinished: _onTraceFinished,
              )
              : isShape() 
                ? TracingGeometricShapesGame(
                    traceGeoMetricShapeModels: [
                      TraceGeoMetricShapeModel(
                        shapes: [
                          MathShapeWithOption(
                            shape: shapesMap[widget.mainData.toLowerCase()] ?? MathShapes.circle,
                            traceShapeOptions: const TraceShapeOptions(innerPaintColor: Color.fromARGB(255, 33, 150, 243), indexColor: Colors.white)
                          )
                        ]
                      ),
                    ],
                    onGameFinished: _onTraceFinished,
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
                )
          
          ),
        )
      ],
    );
  }
}