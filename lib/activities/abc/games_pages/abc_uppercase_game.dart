import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/abc/abc_components/drag_drop_multiple_letters_component.dart';
import 'package:verbalautism/activities/abc/abc_components/tap_component.dart';
import 'package:verbalautism/activities/abc/abc_components/drag_drop_component.dart';
import 'package:verbalautism/activities/abc/abc_components/tap_multiple_letters_component.dart';
import 'package:verbalautism/activities/abc/abc_components/trace_component.dart';

class AbcUppercaseGame extends StatefulWidget {
  const AbcUppercaseGame({super.key});

  @override
  State<AbcUppercaseGame> createState() => _AbcUppercaseGameState();
}

class _AbcUppercaseGameState extends State<AbcUppercaseGame> {
  
  List <String> letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  
  // Variables
  int displaySteps = 1;
  int totalSteps = 1;
  int round = 1;
  final int maxSteps = 30;

  // Random Object
  Random random = Random();

  // Random Number Variables
  late int randomNumber;
  late int randomNumber2;
  late int randomNumber3;
  late List <String> wrongLetters;

  @override
  void initState() {
    randomNumber = random.nextInt(26);
    super.initState();
  }

void setOneWrongNumber(){
    randomNumber2 = random.nextInt(26);

    while(randomNumber2 == randomNumber){
      randomNumber2 = random.nextInt(26);
    }
    
    wrongLetters = ["Uppercase_${letters[randomNumber2]}"];
  }

  void setTwoWrongNumbers(){
    randomNumber2 = random.nextInt(26);
    randomNumber3 = random.nextInt(26);

    while(randomNumber == randomNumber2 || randomNumber == randomNumber3 || randomNumber2 == randomNumber3){
      randomNumber2 = random.nextInt(26);
      randomNumber3 = random.nextInt(26);
    }

    wrongLetters = ["Uppercase_${letters[randomNumber2]}", "Uppercase_${letters[randomNumber3]}"];
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
    
    if (totalSteps % 3 == 1 && totalSteps <= 10) {
      currentActivity = TapComponent(onCompleted: nextStep, letterLink: "Uppercase_${letters[randomNumber]}", letter: letters[randomNumber],);
    } 
    else if (totalSteps % 3 == 2 && totalSteps < 10) {
      currentActivity = DragDropComponent(onCompleted: nextStep, letterLink: "Uppercase_${letters[randomNumber]}", letter: letters[randomNumber],);
    } 
    else if(totalSteps % 3 == 0 && totalSteps < 10){
      currentActivity = TraceComponent(onCompleted: nextStep, letter: letters[randomNumber]);
    } 
    else if(totalSteps % 3 == 1 && totalSteps >= 10){
      currentActivity = TapMultipleLettersComponent(onCompleted: nextStep, correctLetterLink: "Uppercase_${letters[randomNumber]}", wrongLetterLinks: wrongLetters, letter: letters[randomNumber]);
    }
    else if(totalSteps % 3 == 2 && totalSteps >= 10){
      currentActivity = DragDropMultipleLettersComponent(onCompleted: nextStep, correctLetterLink: "Uppercase_${letters[randomNumber]}", wrongLetterLinks: wrongLetters, letter: letters[randomNumber]);
    } 
    else {
      currentActivity = TraceComponent(onCompleted: nextStep, letter: letters[randomNumber]);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(child: Text("Uppercase Letters", style: GoogleFonts.ubuntu(fontSize:24, fontWeight: FontWeight.bold, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_images/32442923_7895078.jpg"),
            fit: BoxFit.cover,
          )
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple, // White background with opacity for readability
              borderRadius: BorderRadius.circular(20),
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
                Text("Round: $round", style: GoogleFonts.ubuntu(fontSize: 24, color: Colors.white),),
                const SizedBox(height: 20,),
                Text("Trial: $displaySteps / 10", style: GoogleFonts.ubuntu(fontSize: 24, color: Colors.white)),
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
