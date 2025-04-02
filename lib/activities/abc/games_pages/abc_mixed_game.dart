import 'dart:math';

import 'package:flutter/material.dart';
import 'package:verbalautism/activities/abc/abc_components/tap_component.dart';
import 'package:verbalautism/activities/abc/abc_components/drag_drop_component.dart';
import 'package:verbalautism/activities/abc/abc_components/trace_component.dart';

class AbcMixedGame extends StatefulWidget {
  const AbcMixedGame({super.key});

  @override
  State<AbcMixedGame> createState() => _AbcMixedGameState();
}

class _AbcMixedGameState extends State<AbcMixedGame> {
  
  List <String> letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  int step = 0;
  final int maxSteps = 10;

  // Random Object
  Random random = Random();
  late int randomNumber;
  late int randomLetterNumber;
  late String namingLetter;

  @override
  void initState() {
    setRandomNumber();
    super.initState();
  }

  void setRandomNumber(){
    randomNumber = random.nextInt(26);
    randomLetterNumber = random.nextInt(2);

    if(randomLetterNumber == 0){
      namingLetter = "Uppercase_";
    } else {
      namingLetter = "Lowercase_";
    }
    
  }

  void nextStep() {

    setState(() {
      // Next Activity
      if(step < maxSteps - 1){
        ++step;
      } 
      
      // Game ends and Restart Game Prompt
      else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Exercise Complete!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    step = 0; // Restart the game
                  });
                  setRandomNumber();
                },
                child: const Text("Restart"),
              ),
            ],
          ),
        );    
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentActivity;
    
    if (step % 3 == 0 || step == maxSteps - 1) {
      currentActivity = TapComponent(onCompleted: nextStep, letterLink: "$namingLetter${letters[randomNumber]}");
    } else if (step % 3 == 1) {
      currentActivity = DragDropComponent(onCompleted: nextStep, letterLink: "$namingLetter${letters[randomNumber]}");
    } else {
      if(namingLetter == "Uppercase_"){
        currentActivity = TraceComponent(
          onCompleted: nextStep, 
          letter: letters[randomNumber]
        );
      } else {
        currentActivity = TraceComponent(
          onCompleted: nextStep, 
          letter: letters[randomNumber].toLowerCase(),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Mixed Letters")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Round: ${step + 1} / $maxSteps", style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            currentActivity,
          ],
        ),
      ),
    );
  }
}
