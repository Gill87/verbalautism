import 'package:flutter/material.dart';
import 'package:verbalautism/components/drawingPainter.dart';
import 'package:verbalautism/components/letterAPainter.dart';

class LowercaseActivity extends StatefulWidget {
  const LowercaseActivity({super.key});

  @override
  State<LowercaseActivity> createState() => _LowercaseActivityState();
}

class _LowercaseActivityState extends State<LowercaseActivity> {

  List <List<Offset>> strokes = [];
  List <Offset> currentStroke = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lowercase Letters"),
      ),

      body: Center(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.4,
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                currentStroke = [details.localPosition]; // Start new stroke
              });
            },
            onPanUpdate: (details) {
              setState(() {
                currentStroke.add(details.localPosition); // Add points
              });
            },
            onPanEnd: (details) {
              setState(() {
                strokes.add(List.from(currentStroke)); // Store completed stroke
                currentStroke.clear();
              });

            },
            child: CustomPaint(
              foregroundPainter: LetterAPainter(stepNumber: 1),
              painter: DrawingPainter(strokes, currentStroke),
            ),
          )
        
        ),
      ),
      
    );
  }
}