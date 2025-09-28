// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/game%20components/drag_drop_component.dart';
import 'package:verbalautism/components/game%20components/drag_drop_multiple_objects_component.dart';
import 'package:verbalautism/components/game%20components/tap_component.dart';
import 'package:verbalautism/components/game%20components/tap_multiple_objects_component.dart';
import 'package:verbalautism/components/game_loading_indicator.dart';
import 'package:verbalautism/features/home/pages/home_page.dart';

class ObjectGame extends StatefulWidget {
  const ObjectGame({
    required this.selectedObject,
    super.key
  });

  final String selectedObject;

  @override
  State<ObjectGame> createState() => _ObjectGameState();
}

class _ObjectGameState extends State<ObjectGame> {
  // List
  List<String> objects = [
    "Book",
    "Backpack",
    "Car",
    "Clock",
    "Computer",
    "Crayon",
    "Pen",
    "Pencil",
    "Scissors",
    "TV",
    "Ruler",
    "Chair",
    "Teddy Bear",
  ];
  List<int> stepDurations = []; // store all durations (in seconds)
  List<String> shuffleWordList = [];

  List<String> objectQueue = [];
  int queueIndex = 0;

  // Variables
  int incorrectAnswer = 0;
  int correctAnswer = 0;
  int displaySteps = 1;
  int totalSteps = 1;
  int round = 1;
  int gamesPlayedCount = 0;
  final int maxSteps = 30;
  bool isInitializing = true;
  bool isPaused = false;
  bool randomize = false;
  DateTime? stepStartTime;
  double durationAvg = 0;
  Timer? stepTimer;

  // Random
  final random = Random();
  late int randomNumber;
  late int randomNumber2;
  late int randomNumber3;
  late int correctIndex;
  late List<String> wrongObjects;


  String convertToAssetLink(String objectName){
    if(objectName.contains(" ")) {
      objectName = objectName.replaceAll(" ", "_");
    }
    objectName = objectName.toLowerCase();
    return objectName;
  }
  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> populateShuffleList() async {
    setState(() {
      isInitializing = true;
    });

    shuffleWordList = await fetchShuffleWords();
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      isInitializing = false;
    });
  }

  void _assignFromQueue() {
    if (objectQueue.isEmpty || queueIndex >= objectQueue.length) {
      objectQueue = List.from(objects)..shuffle(random);
      queueIndex = 0;
    }

    String chosenObject = objectQueue[queueIndex];
    randomNumber = objects.indexOf(chosenObject);
    correctIndex = randomNumber;

    queueIndex++;
  }


  void _initializeGame() async {
    ++gamesPlayedCount;
    
    // Initialize the queue first if it's empty
    if (objectQueue.isEmpty) {
      objectQueue = List.from(objects)..shuffle(random);
      queueIndex = 0;
    }
    
    // Check if we should use shuffle words (every 3rd game)
    if (widget.selectedObject == "Shuffle" && gamesPlayedCount % 3 == 0) {
      await populateShuffleList();
      
      // Only remove items if queueIndex is valid and within bounds
      if (queueIndex > 0 && queueIndex - 1 < objectQueue.length) {
        shuffleWordList.remove(objectQueue[queueIndex - 1]); // Previous
      }
      if (queueIndex < objectQueue.length) {
        shuffleWordList.remove(objectQueue[queueIndex]); // Current
      }
            
      if (shuffleWordList.isNotEmpty) {
        String chosenTerm = shuffleWordList[random.nextInt(shuffleWordList.length)];
        randomNumber = objects.indexOf(chosenTerm);
        if (randomNumber != -1) {
          correctIndex = randomNumber;
        } else {
          // If the chosen term is not in objects list, fall back to queue
          _assignFromQueue();
        }
      } else {
        _assignFromQueue();
      }
    } else if (widget.selectedObject.isNotEmpty && 
              widget.selectedObject != "Shuffle" && 
              !randomize) {
      // Use specific selected objects
      randomNumber = objects.indexOf(widget.selectedObject);
      if (randomNumber == -1) {
        _assignFromQueue();
      } else {
        correctIndex = randomNumber;
      }
    } else {
      // Use queue for random selection
      _assignFromQueue();
    }

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        startStepTimer();
      });
    }
  }


  @override
  void dispose() {
    stepTimer?.cancel(); // Cancel any active timer
    super.dispose();
  }

  Future<List<String>> fetchShuffleWords() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    // read all lowercaseobjectsReports for the user
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("objectsReports")
        .get();

    Set<String> shuffleWordSet = {};  // use a set to avoid duplicates

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final int incorrect = data["incorrect"] ?? 0;
      final String word = data["word"] ?? "";

      if (incorrect > 2 && word.isNotEmpty) {
        shuffleWordSet.add(word);
      }
    }
    return shuffleWordSet.toList();
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

    randomNumber2 = random.nextInt(objects.length);

    while(randomNumber2 == randomNumber){
      randomNumber2 = random.nextInt(objects.length);
    }

    wrongObjects = [convertToAssetLink(objects[randomNumber2])];
  }

  void setTwoWrongNumbers(){
    randomNumber2 = random.nextInt(objects.length);
    randomNumber3 = random.nextInt(objects.length);

    while(randomNumber == randomNumber2 || randomNumber == randomNumber3 || randomNumber2 == randomNumber3){
      randomNumber2 = random.nextInt(objects.length);
      randomNumber3 = random.nextInt(objects.length);
    }

    wrongObjects = [convertToAssetLink(objects[randomNumber2]), convertToAssetLink(objects[randomNumber3])];
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
    correctAnswer = 0;
    incorrectAnswer = 0;

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
          gameType: "objects",
          correct: correctAnswer,
          incorrect: 0,
          roundNumber: round,
          averageDuration: calculateAverageDuration(),
          word: objects[correctIndex],
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
            gameType: "objects",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: objects[correctIndex],
          );
          repeatRound(2);
        } else {
          uploadRoundResult(
            gameType: "objects",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: objects[correctIndex],
          );
        }
      }

      // ✅ Round 3 check
      if (totalSteps >= 20 && totalSteps < 30) {
        round3();
      }

      // ❌ Check Incorrect Answers at the end of Round 3
      if (totalSteps == 30 && round == 3) {
        if (incorrectAnswer > 2) {
          uploadRoundResult(
            gameType: "objects",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: objects[correctIndex],
          );
          repeatRound(3);
        } else {
          uploadRoundResult(
            gameType: "objects",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: objects[correctIndex],
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

      // 🎯 Game ends (continue to next random activity)
      else {
        // Pause
        setState(() {
          isPaused = true;
        });

        showDialog(
          context: context,
          barrierDismissible: false, // prevent closing by tapping outside
          builder: (context) {
            // Schedule auto-close
            Future.delayed(const Duration(seconds: 2), () {
              if(!mounted) return;
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
                setState(() {
                  randomize = true;
                  totalSteps = 1;
                  round = 1;
                  displaySteps = 1;
                  stepTimer?.cancel();
                  isPaused = false;
                });
                _initializeGame(); // reset the game state
              }
            });

            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 33, 150, 243),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Exercise Complete!",
                style: GoogleFonts.ubuntu(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              content: Text(
                "Good job! Moving to next activity...",
                style: GoogleFonts.ubuntu(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            );
          },
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
    if (isInitializing) {
      return const GameLoadingIndicator(titleHeader: "Objects"); 
    }
    
    Widget currentActivity;
    
    if (totalSteps % 2 == 1 && totalSteps <= 10) {
      currentActivity = TapComponent(onCompleted: nextStep, assetLink: convertToAssetLink(objects[randomNumber]), mainData: objects[correctIndex], onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/objects_images/", objectVariation: "Object",);
    } 
    else if (totalSteps % 2 == 0 && totalSteps <= 10) {
      currentActivity = DragDropComponent(onCompleted: nextStep, assetLink: convertToAssetLink(objects[randomNumber]), mainData: objects[correctIndex], onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/objects_images/", objectVariation: "Object",);
    } 
    else if(totalSteps % 2 == 1 && totalSteps >= 10){
      currentActivity = TapMultipleObjectsComponent(onCompleted: nextStep, correctAssetLink: convertToAssetLink(objects[correctIndex]), wrongAssetLinks: wrongObjects, mainData: objects[correctIndex], onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/objects_images/", objectVariation: "Object",);
    }
    else {
      currentActivity = DragDropMultipleObjectsComponent(onCompleted: nextStep, correctAssetLinks: convertToAssetLink(objects[correctIndex]), wrongAssetLinks: wrongObjects, mainData: objects[correctIndex], onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/objects_images/", objectVariation: "Object",);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Objects", style: GoogleFonts.ubuntu(fontSize:24, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_images/colorful_bg.webp"),
            fit: BoxFit.cover,
          )
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: containerColor, // Black except for flash
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.5), // Shadow color
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