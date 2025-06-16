import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  
  // Variables
  int displaySteps = 1;
  int totalSteps = 1;
  int round = 1;
  final int maxSteps = 30;

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

 void round2(){
    setOneWrongNumber();
    round = 2;
  }

  void round3(){
    setTwoWrongNumbers();
    round = 3;
  }

  void nextStep() {
    
    setState(() {

      // Check round 2
      if(totalSteps >= 10 && totalSteps < 20){
        round2();
      }

      // Check round 3
      if(totalSteps >= 20){
        round3();
      }
      
      // Check total steps
      if(totalSteps < maxSteps){
      // Increment step
        ++totalSteps;

        // Correctly modify display steps number
        displaySteps = totalSteps % 10;
        if(displaySteps == 0){
          displaySteps = 10;
        }
      }

      // Or Game ends and Restart Game Prompt
      else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Exercise Complete!"),
            actions: [
              TextButton(
                
                // Restart Game
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    totalSteps = 1;
                    round = 1;
                    displaySteps = 1; 
                  });
                  randomNumber = random.nextInt(26);
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

    if (totalSteps % 3 == 1 && totalSteps < 10) {
      if(namingLetter == "Uppercase_"){
        currentActivity = TapComponent(onCompleted: nextStep, letterLink: "$namingLetter${letters[randomNumber]}", letter: letters[randomNumber],);
      } else {
        currentActivity = TapComponent(onCompleted: nextStep, letterLink: "$namingLetter${letters[randomNumber]}", letter: letters[randomNumber].toLowerCase(),);
      }
    } 
    else if (totalSteps % 3 == 2 && totalSteps < 10) {
      if(namingLetter == "Uppercase_"){
        currentActivity = DragDropComponent(onCompleted: nextStep, letterLink: "$namingLetter${letters[randomNumber]}", letter: letters[randomNumber]);
      } else {
        currentActivity = DragDropComponent(onCompleted: nextStep, letterLink: "$namingLetter${letters[randomNumber]}", letter: letters[randomNumber].toLowerCase());
      }
    } 
    else if(totalSteps % 3 == 0 && totalSteps < 10){
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
    else if(totalSteps % 3 == 1 && totalSteps >= 10){
      if(namingLetter == "Uppercase_"){
        currentActivity = TapMultipleLettersComponent(onCompleted: nextStep, correctLetterLink: "$namingLetter${letters[randomNumber]}", wrongLetterLinks: wrongLetters, letter: letters[randomNumber],);
      } else {
        currentActivity = TapMultipleLettersComponent(onCompleted: nextStep, correctLetterLink: "$namingLetter${letters[randomNumber]}", wrongLetterLinks: wrongLetters, letter: letters[randomNumber].toLowerCase(),);
      }
    } 
    else if(totalSteps % 3 == 2 && totalSteps >= 10){
      if(namingLetter == "Uppercase_"){
        currentActivity = DragDropMultipleLettersComponent(onCompleted: nextStep, correctLetterLink: "$namingLetter${letters[randomNumber]}", wrongLetterLinks: wrongLetters, letter: letters[randomNumber],);
      } else {
        currentActivity = DragDropMultipleLettersComponent(onCompleted: nextStep, correctLetterLink: "$namingLetter${letters[randomNumber]}", wrongLetterLinks: wrongLetters, letter: letters[randomNumber].toLowerCase(),);
      }
    } 
    else {
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
        centerTitle: true,
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
                Text("Round: $round", style: GoogleFonts.ubuntu(fontSize: 24),),
                const SizedBox(height: 20,),
                Text("Trial: $displaySteps / 10", style: GoogleFonts.ubuntu(fontSize: 24)),
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
