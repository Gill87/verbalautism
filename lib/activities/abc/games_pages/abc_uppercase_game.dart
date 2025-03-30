import 'dart:math';

import 'package:flutter/material.dart';
import 'package:verbalautism/activities/abc/games_pages/TapComponent.dart';
import 'package:verbalautism/activities/abc/games_pages/DragDropComponent.dart';
import 'package:verbalautism/activities/abc/games_pages/TraceComponent.dart';

class AbcUppercaseGame extends StatefulWidget {
  const AbcUppercaseGame({super.key});

  @override
  State<AbcUppercaseGame> createState() => _AbcUppercaseGameState();
}

class _AbcUppercaseGameState extends State<AbcUppercaseGame> {
  
  List <String> letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y', 'Z'];
  int step = 0;
  final int maxSteps = 10;

  // Random Object
  Random random = Random();
  late int randomNumber;

  @override
  void initState() {
    setRandomNumber();
    super.initState();
  }

  void setRandomNumber(){
    randomNumber = random.nextInt(24);
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
      currentActivity = TapComponent(onCompleted: nextStep, letterLink: "Uppercase_${letters[randomNumber]}",);
    } else if (step % 3 == 1) {
      currentActivity = DragDropComponent(onCompleted: nextStep, letterLink: "Uppercase_${letters[randomNumber]}",);
    } else {
      currentActivity = TraceComponent(onCompleted: nextStep, letter: letters[randomNumber],);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Uppercase Letters")),
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
