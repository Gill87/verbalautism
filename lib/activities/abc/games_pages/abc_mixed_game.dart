import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/game%20components/drag_drop_multiple_objects_component.dart';
import 'package:verbalautism/components/game%20components/tap_component.dart';
import 'package:verbalautism/components/game%20components/drag_drop_component.dart';
import 'package:verbalautism/components/game%20components/tap_multiple_objects_component.dart';
import 'package:verbalautism/components/game%20components/trace_component.dart';
import 'package:verbalautism/features/home/pages/home_page.dart';

class AbcMixedGame extends StatefulWidget {
  
  const AbcMixedGame({
    super.key,
  });

  @override
  State<AbcMixedGame> createState() => _AbcMixedGameState();
}

class _AbcMixedGameState extends State<AbcMixedGame> {
  
  List <String> letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  List<int> stepDurations = []; // store all durations (in seconds)

  // Variables
  int incorrectAnswer = 0;
  int correctAnswer = 0;
  int displaySteps = 1;
  int totalSteps = 1;
  int round = 1;
  final int maxSteps = 30;
  bool isPaused = false;
  DateTime? stepStartTime;
  double durationAvg = 0;
  Timer? stepTimer;

  // Random Object
  Random random = Random();
  late int randomNumber;
  late int randomNumber2;
  late int randomNumber3;
  late List <String> wrongLetters;
  late String namingLetter;
  late String namingLetter2;
  late String namingLetter3;
  late int correctIndex;

  @override
  void initState() {
    setRandomNumber();
    wrongLetters = [];
    
    super.initState();
  }

  void screenTimeoutDialog(){
    // Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red, // Red background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Soft edges
        ),
        title: Center(
          child: Text(
            "Session Timed Out",
            style: GoogleFonts.ubuntu(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Center(
          heightFactor: 1, // Keeps content vertically centered
          child: Text(
            "No activity detected for 2 minutes. Returning to Home Page...",
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    // Automatically close the dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    });
  }
  
  // When a new step starts, record start time
  void startStepTimer() {
    stepStartTime = DateTime.now();
    
    // cancel any previous timer
    stepTimer?.cancel();

    // don't count time while paused dialogs are up
    if (isPaused) return;

    // hard 2-minute timeout for THIS trial
    stepTimer = Timer(const Duration(minutes: 2), () {
      if (!mounted) return;

      screenTimeoutDialog();
    });
  }

  // When step ends, calculate duration
  void endStepTimer(int stepNumber) {

    stepTimer?.cancel(); // Cancel timeout if trial finished normally

    if (stepStartTime != null) {
      final duration = DateTime.now().difference(stepStartTime!).inSeconds;
      stepDurations.add(duration);
    }
  }

  double calculateAverageDuration() {
    if (stepDurations.isEmpty) return 0;
    final avg = stepDurations.reduce((a, b) => a + b) / stepDurations.length;
    return double.parse(avg.toStringAsFixed(1));
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

  @override
  void dispose() {
    super.dispose();
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
    correctIndex = randomNumber;
    
    int randomLetterNumber = random.nextInt(2);

    if(randomLetterNumber == 0){
      namingLetter = "Uppercase_";
    } else {
      namingLetter = "Lowercase_";
    }
    
  }

  void nextRoundDialog(int roundNumber){

    // Pause
    setState(() {
      isPaused = true;
    });

    // Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243), // Blue background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Soft edges
        ),
        title: Center(
          child: Text(
            "Moving to Next Round",
            style: GoogleFonts.ubuntu(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Center(
          heightFactor: 1, // Keeps content vertically centered
          child: Text(
            "Round ${roundNumber - 1} Complete! Moving to Round $roundNumber...",
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    // Automatically close the dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        setState(() {
          isPaused = false;
        });
      }
    });
  }

  void repeatRoundDialog(int roundNumber){

    // Pause
    setState(() {
      isPaused = true;
    });
  
    // Reset Counters
    incorrectAnswer = 0;
    correctAnswer = 0;

    // Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red, // Red background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Soft edges
        ),
        title: Center(
          child: Text(
            "Try Again!",
            style: GoogleFonts.ubuntu(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Center(
          heightFactor: 1, // Keeps content vertically centered
          child: Text(
            "Too many incorrect answers. Repeating Round $roundNumber...",
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    // Automatically close the dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        setState(() {
          isPaused = false;
        });
      }
    });
  }

  void repeatRound(int roundNumber){
    if(roundNumber == 2){
      totalSteps = 10;
      displaySteps = 1;
      round = 2;
      incorrectAnswer = 0;
      correctAnswer = 0;
      repeatRoundDialog(2);
    } else {
      totalSteps = 20;
      displaySteps = 1;
      round = 3;
      incorrectAnswer = 0;
      correctAnswer = 0;
      repeatRoundDialog(3);
    }
  }

 void round2(){
    if(totalSteps == 10){
      nextRoundDialog(2);
    }
    setOneWrongNumber();
    round = 2;
  }

  void round3(){
    if(totalSteps == 20){
      nextRoundDialog(3);
    }
    setTwoWrongNumbers();
    round = 3;
  }

  void nextStep() {
    setState(() {
      // ⏱ End timer for current step
      endStepTimer(totalSteps);

      // ✅ End of Round 1
      if (totalSteps == 10 && round == 1) {
        uploadRoundResult(
          gameType: "mixedLetters",
          correct: correctAnswer,
          incorrect: 0,
          roundNumber: round,
          averageDuration: calculateAverageDuration(),
          word: letters[correctIndex],
        );
      }

      // ✅ Round 2 check
      if (totalSteps >= 10 && totalSteps < 20) {
        displaySteps = totalSteps % 10;
        round2();
      }

      // ❌ Check Incorrect Answers at the end of Round 2
      if (totalSteps == 20 && round == 2) {
        if (incorrectAnswer > 2) {
          uploadRoundResult(
            gameType: "mixedLetters",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: letters[correctIndex],
          );
          repeatRound(2);
        } else {
          uploadRoundResult(
            gameType: "mixedLetters",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: letters[correctIndex],
          );
        }
      }

      // ✅ Round 3 check
      if (totalSteps >= 20) {
        round3();
      }

      // ❌ Check Incorrect Answers at the end of Round 3
      if (totalSteps == 30 && round == 3) {
        if (incorrectAnswer > 2) {
          uploadRoundResult(
            gameType: "mixedLetters",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: letters[correctIndex],
          );
          repeatRound(3);
        } else {
          uploadRoundResult(
            gameType: "mixedLetters",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: letters[correctIndex],
          );
        }
      }

      // ✅ Progress through steps
      if (totalSteps < maxSteps) {
        // Increment step
        ++totalSteps;

        // ⏱ Start timer for next step
        startStepTimer();

        // Correctly modify display steps number
        displaySteps = totalSteps % 10;
        if (displaySteps == 0) {
          displaySteps = 10;
        }
      }

      // 🎯 Game ends and Restart/Home Prompt
      else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 33, 150, 243), // Blue background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Soft edges
            ),
            title: Text(
              "Exercise Complete!",
              style: GoogleFonts.ubuntu(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromARGB(255, 33, 150, 243),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    totalSteps = 1;
                    round = 1;
                    displaySteps = 1;
                  });
                  // Reset the game state
                  initState();
                },
                child: Text(
                  "Restart",
                  style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromARGB(255, 33, 150, 243),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: Text(
                  "Home",
                  style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
  Color containerColor = Colors.black;

  void triggerCorrectFlash() {
    ++correctAnswer;  
    
    setState(() {
      containerColor = Colors.lightGreen;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          containerColor = Colors.black;
        });
      }
    });
  }

  void triggerIncorrectFlash() {
    ++incorrectAnswer;

    setState(() {
      containerColor = Colors.red;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          containerColor = Colors.black;
        });
      }
    });
  }
  
  Future<void> uploadRoundResult({
    required String gameType, // e.g. "sightWord"
    required int correct,
    required int incorrect,
    required int roundNumber,
    required double averageDuration,
    required String word,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("${gameType}Reports") // e.g. sightWordReports
        .add({
      "correct": correct,
      "incorrect": incorrect,
      "round": roundNumber,
      "averageDuration": averageDuration,
      "word": word,
      "createdAt": FieldValue.serverTimestamp(),
    });

    incorrectAnswer = 0;
    correctAnswer = 0;
    stepDurations.clear(); // Clear durations for next round
  }
  
  @override
  Widget build(BuildContext context) {
    Widget currentActivity;

    if (totalSteps % 3 == 1 && totalSteps <= 10) {
      if(namingLetter == "Uppercase_"){
        currentActivity = TapComponent(onCompleted: nextStep, assetLink: "$namingLetter${letters[randomNumber]}", mainData: letters[randomNumber], onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/abc_images/", objectVariation: "Letter",);
      } else {
        currentActivity = TapComponent(onCompleted: nextStep, assetLink: "$namingLetter${letters[randomNumber]}", mainData: letters[randomNumber].toLowerCase(), onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/abc_images/", objectVariation: "Letter",);
      }
    } 
    else if (totalSteps % 3 == 2 && totalSteps <= 10) {
      if(namingLetter == "Uppercase_"){
        currentActivity = DragDropComponent(onCompleted: nextStep, assetLink: "$namingLetter${letters[randomNumber]}", mainData: letters[randomNumber], onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/abc_images/", objectVariation: "Letter",);
      } else {
        currentActivity = DragDropComponent(onCompleted: nextStep, assetLink: "$namingLetter${letters[randomNumber]}", mainData: letters[randomNumber].toLowerCase(), onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/abc_images/", objectVariation: "Letter",);
      }
    } 
    else if(totalSteps % 3 == 0 && totalSteps <= 10){
      if(namingLetter == "Uppercase_"){
        currentActivity = TraceComponent(
          onCompleted: nextStep, 
          mainData: letters[randomNumber],
          onCorrectAction: triggerCorrectFlash,
          objectVariation: "Letter",
        );
      } else {
        currentActivity = TraceComponent(
          onCompleted: nextStep, 
          mainData: letters[randomNumber].toLowerCase(),
          onCorrectAction: triggerCorrectFlash,
          objectVariation: "Letter",
        );
      }   
    } 
    else if(totalSteps % 3 == 1 && totalSteps > 10){
      if(namingLetter == "Uppercase_"){
        currentActivity = TapMultipleObjectsComponent(onCompleted: nextStep, correctAssetLink: "$namingLetter${letters[randomNumber]}", wrongAssetLinks: wrongLetters, mainData: letters[randomNumber], onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/abc_images/", objectVariation: "Letter",);
      } else {
        currentActivity = TapMultipleObjectsComponent(onCompleted: nextStep, correctAssetLink: "$namingLetter${letters[randomNumber]}", wrongAssetLinks: wrongLetters, mainData: letters[randomNumber].toLowerCase(), onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/abc_images/", objectVariation: "Letter",);
      }
    } 
    else if(totalSteps % 3 == 2 && totalSteps > 10){
      if(namingLetter == "Uppercase_"){
        currentActivity = DragDropMultipleObjectsComponent(onCompleted: nextStep, correctAssetLinks: "$namingLetter${letters[randomNumber]}", wrongAssetLinks: wrongLetters, mainData: letters[randomNumber], onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/abc_images/", objectVariation: "Letter",);
      } else {
        currentActivity = DragDropMultipleObjectsComponent(onCompleted: nextStep, correctAssetLinks: "$namingLetter${letters[randomNumber]}", wrongAssetLinks: wrongLetters, mainData: letters[randomNumber].toLowerCase(), onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/abc_images/", objectVariation: "Letter",);
      }
    } 
    else {
      if(namingLetter == "Uppercase_"){
        currentActivity = TraceComponent(
          onCompleted: nextStep, 
          mainData: letters[randomNumber],
          onCorrectAction: triggerCorrectFlash,
          objectVariation: "Letter",
        );
      } else {
        currentActivity = TraceComponent(
          onCompleted: nextStep, 
          mainData: letters[randomNumber].toLowerCase(),
          onCorrectAction: triggerCorrectFlash,
          objectVariation: "Letter",
        );
      }    
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(child: Text("Mixed Letters", style: GoogleFonts.ubuntu(fontSize:24, fontWeight: FontWeight.bold, color: Colors.white))),
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
              color: containerColor, // Dynamic flash
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5), // Shadow color
                  blurRadius: 10, // Spread of shadow
                  offset: const Offset(0, 4), // Position of shadow (X, Y)
                ),
              ],
            ),           
            child: !isPaused ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Round: $round", style: GoogleFonts.ubuntu(fontSize: 24, color: Colors.white),),
                const SizedBox(height: 20,),
                Text("Trial: $displaySteps / 10", style: GoogleFonts.ubuntu(fontSize: 24, color: Colors.white)),
                const SizedBox(height: 20),
                currentActivity,
              ],
            ) : const SizedBox(),
          ),
        ),
      ),
    );
  }
}
