import 'package:flutter/material.dart';
import 'package:tracing_game/tracing_game.dart';
// import 'package:verbalautism/components/drawingPainter.dart';
// import 'package:verbalautism/components/letterAPainter.dart';

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
          child: TracingWordGame(
            words: [
              TraceWordModel(
                word: "Is",
                traceShapeOptions: const TraceShapeOptions(indexColor: Colors.green),
              ),
            ],

          )
        ),
      ),
      
    );
  }
}