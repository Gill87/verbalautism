import 'dart:math';

import 'package:flutter/material.dart';
import 'package:verbalautism/activities/abc/abc_components/drag_drop_multiple_letters_component.dart';
import 'package:verbalautism/activities/abc/abc_components/tap_component.dart';
import 'package:verbalautism/activities/abc/abc_components/drag_drop_component.dart';
import 'package:verbalautism/activities/abc/abc_components/tap_multiple_letters_component.dart';
import 'package:verbalautism/activities/abc/abc_components/trace_component.dart';

class AbcMixedGame extends StatefulWidget {
  const AbcMixedGame({super.key});

  @override
  State<AbcMixedGame> createState() => _AbcMixedGameState();
}

class _AbcMixedGameState extends State<AbcMixedGame> {
  
  List <String> letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  int step = 1;
  final int maxSteps = 15;

  // Random Object
  Random random = Random();
  late int randomNumber;
  late int randomNumber2;
  late int randomNumber3;
  late List <String> wrongLetters;
  late String namingLetter;
  late String namingLetter2;
  late String namingLetter3;


  @override
  void initState() {
    setRandomNumber();
    super.initState();
  }

  void setOneWrongNumber(){
    int randomLetterNumber = random.nextInt(2);
    randomNumber2 = random.nextInt(26);

    while(randomNumber2 == randomNumber){
      randomNumber2 = random.nextInt(26);
    }

    if(randomLetterNumber == 0){
      namingLetter2 = "Uppercase_";
    } else {
      namingLetter2 = "Lowercase_";
    }
    
    wrongLetters = ["$namingLetter2${letters[randomNumber2]}"];
  }

  void setTwoWrongNumbers(){
    int randomLetterNumber = random.nextInt(2);
    int randomLetterNumber2 = random.nextInt(2);

    randomNumber2 = random.nextInt(26);
    randomNumber3 = random.nextInt(26);

    while(randomNumber == randomNumber2 || randomNumber == randomNumber3 || randomNumber2 == randomNumber3){
      randomNumber2 = random.nextInt(26);
      randomNumber3 = random.nextInt(26);
    }

    if(randomLetterNumber == 0){
      namingLetter2 = "Uppercase_";
    } else {
      namingLetter2 = "Lowercase_";
    }

    if(randomLetterNumber2 == 0){
      namingLetter3 = "Uppercase_";
    } else {
      namingLetter3 = "Lowercase_";
    }

    wrongLetters = ["$namingLetter2${letters[randomNumber2]}", "$namingLetter3${letters[randomNumber3]}"];
  }

  void setRandomNumber(){
    randomNumber = random.nextInt(26);
    int randomLetterNumber = random.nextInt(2);

    if(randomLetterNumber == 0){
      namingLetter = "Uppercase_";
    } else {
      namingLetter = "Lowercase_";
    }
    
  }

  void nextStep() {

    setState(() {
      if(step >= 9 && step < 13){
        setOneWrongNumber();
      }

      if(step >= 12){
        setTwoWrongNumbers();
      }

      // Next Activity
      if(step < maxSteps){
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
                    step = 1; // Restart the game
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

    if (step % 3 == 1 && step < 10) {
      currentActivity = TapComponent(onCompleted: nextStep, letterLink: "$namingLetter${letters[randomNumber]}", letter: letters[randomNumber],);
    } else if (step % 3 == 2 && step < 10) {
      currentActivity = DragDropComponent(onCompleted: nextStep, letterLink: "$namingLetter${letters[randomNumber]}", letter: letters[randomNumber]);
    } else if(step % 3 == 0 && step < 10){
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
    } else if(step % 3 == 1 && step >= 10){
      currentActivity = TapMultipleLettersComponent(onCompleted: nextStep, correctLetterLink: "$namingLetter${letters[randomNumber]}", wrongLetterLinks: wrongLetters, letter: letters[randomNumber],);
    } else if(step % 3 == 2 && step >= 10){
      currentActivity = DragDropMultipleLettersComponent(onCompleted: nextStep, correctLetterLink: "$namingLetter${letters[randomNumber]}", wrongLetterLinks: wrongLetters, letter: letters[randomNumber],);
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/background_images/Clouds.png"),
            fit: BoxFit.cover,
          )
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5), // White background with opacity for readability
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Shadow color
                  blurRadius: 10, // Spread of shadow
                  offset: const Offset(0, 4), // Position of shadow (X, Y)
                ),
              ],
            ),           
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Round: ${step} / $maxSteps", style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                currentActivity,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
