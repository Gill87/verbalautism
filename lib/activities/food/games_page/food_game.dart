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

class FoodGame extends StatefulWidget {
  const FoodGame({
    super.key,
    required this.selectedFood,
  });

  final String selectedFood;

  @override
  State<FoodGame> createState() => _FoodGameState();
}

class _FoodGameState extends State<FoodGame> {
  // List
  List<String> foods = [
    "Apple",
    "Banana",
    "Bread",
    "Bacon",
    "Cereal",
    "Chips",
    "Egg",
    "Milk",
    "Orange",
    "Rice",
    "Strawberry",
    "Burrito",
    "Pancakes",
    "Pie",
    "Pizza",
    "Sandwich",
    "Brownies",
    "Chicken Wings",
    "Corn",
    "Dumplings",
    "Fish and Chips",
    "French Fries",
    "Grapes",
    "Hot Dog",
    "Mac and Cheese",
    "Ramen",
    "Salad",
    "Sushi",
    "Tacos",
    "Hash Brown",
    "Waffles",
    "Yogurt",
    "Bagel"
    ];
  List<int> stepDurations = []; // store all durations (in seconds)
  Set<String> shuffleWordSet = {};  // use a set to avoid duplicates
  Set<String> usedWords = {};    // track used words to avoid repetition
  
  // Variables
  int incorrectAnswer = 0;
  int correctAnswer = 0;
  int displaySteps = 1;
  int totalSteps = 1;
  int gamesPlayedCount = 0;
  int round = 1;
  final int maxSteps = 30;
  bool isPaused = false;
  bool randomize = false;
  bool isInitializing = false;
  DateTime? stepStartTime;
  double durationAvg = 0;
  Timer? stepTimer;

  // Random
  final random = Random();
  late int randomNumber;
  late int randomNumber2;
  late int randomNumber3;
  late int correctIndex;
  late List<String> wrongFoods;


  String convertToAssetLink(String foodName){
    if(foodName.contains(" ")) {
      foodName = foodName.replaceAll(" ", "_");
    }
    foodName = foodName.toLowerCase();
    return foodName;
  }

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() async {

    // Increment games played count
    ++gamesPlayedCount;

    setState(() {
      isInitializing = true;
    });
    
    if (widget.selectedFood == "Shuffle" && gamesPlayedCount % 3 == 0) {
      final words = await fetchShuffleWords();
      print("Words: ########" + words.toString());

      if (words.isNotEmpty) {
        String chosenWord = words[random.nextInt(words.length)];
        randomNumber = foods.indexOf(chosenWord);
        correctIndex = randomNumber;
      } else {
        // Fallback if no shuffle words found
        randomNumber = random.nextInt(foods.length);
        correctIndex = randomNumber;
      }
    } else {
      if (widget.selectedFood != "" && randomize == false) {
        randomNumber = foods.indexOf(widget.selectedFood);
        correctIndex = randomNumber;
        
        if (randomNumber == -1) {
          randomNumber = random.nextInt(foods.length);
          correctIndex = randomNumber;
        }
      } else {
        randomNumber = random.nextInt(foods.length);
        correctIndex = randomNumber;
      }
    }

    Future.delayed(const Duration(milliseconds: 1000)); // Simulate loading delay
    
    setState(() {
      isInitializing = false;
    });

    usedWords.add(foods[correctIndex]);

    // Ensure UI updates and start timer
    if (mounted) {
      setState(() {});
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

    // read all lowercasefoodsReports for the user
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("foodsReports")
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final int incorrect = data["incorrect"] ?? 0;
      final String word = data["word"] ?? "";

      if (incorrect > 2 && word.isNotEmpty && !usedWords.contains(word)) {
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

      print("⏱ Step $stepNumber took $duration seconds");
    }
  }

  double calculateAverageDuration() {
    if (stepDurations.isEmpty) return 0;
    final avg = stepDurations.reduce((a, b) => a + b) / stepDurations.length;
    return double.parse(avg.toStringAsFixed(1));
  }

  void setOneWrongNumber(){

    randomNumber2 = random.nextInt(foods.length);

    while(randomNumber2 == randomNumber){
      randomNumber2 = random.nextInt(foods.length);
    }

    wrongFoods = [convertToAssetLink(foods[randomNumber2])];
  }

  void setTwoWrongNumbers(){
    randomNumber2 = random.nextInt(foods.length);
    randomNumber3 = random.nextInt(foods.length);

    while(randomNumber == randomNumber2 || randomNumber == randomNumber3 || randomNumber2 == randomNumber3){
      randomNumber2 = random.nextInt(foods.length);
      randomNumber3 = random.nextInt(foods.length);
    }

    wrongFoods = [convertToAssetLink(foods[randomNumber2]), convertToAssetLink(foods[randomNumber3])];
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
      correctAnswer = 0;
      incorrectAnswer = 0;
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
          gameType: "foods",
          correct: correctAnswer,
          incorrect: 0,
          roundNumber: round,
          averageDuration: calculateAverageDuration(),
          word: foods[correctIndex],
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
            gameType: "foods",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: foods[correctIndex],
          );
          repeatRound(2);
        } else {
          uploadRoundResult(
            gameType: "foods",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: foods[correctIndex],
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
            gameType: "foods",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: foods[correctIndex],
          );
          repeatRound(3);
        } else {
          uploadRoundResult(
            gameType: "foods",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: foods[correctIndex],
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
                initState(); // reset the game state
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
      return const GameLoadingIndicator(titleHeader: "Foods"); 
    }
    
    Widget currentActivity;
    
    if (totalSteps % 2 == 1 && totalSteps <= 10) {
      currentActivity = TapComponent(onCompleted: nextStep, assetLink: convertToAssetLink(foods[randomNumber]), mainData: foods[correctIndex], onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/food_images/", objectVariation: "Food",);
    } 
    else if (totalSteps % 2 == 0 && totalSteps <= 10) {
      currentActivity = DragDropComponent(onCompleted: nextStep, assetLink: convertToAssetLink(foods[randomNumber]), mainData: foods[correctIndex], onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/food_images/", objectVariation: "Food",);
    } 
    else if(totalSteps % 2 == 1 && totalSteps >= 10){
      currentActivity = TapMultipleObjectsComponent(onCompleted: nextStep, correctAssetLink: convertToAssetLink(foods[correctIndex]), wrongAssetLinks: wrongFoods, mainData: foods[correctIndex], onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/food_images/", objectVariation: "Food",);
    }
    else {
      currentActivity = DragDropMultipleObjectsComponent(onCompleted: nextStep, correctAssetLinks: convertToAssetLink(foods[correctIndex]), wrongAssetLinks: wrongFoods, mainData: foods[correctIndex], onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/food_images/", objectVariation: "Food",);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Foods", style: GoogleFonts.ubuntu(fontSize:24, fontWeight: FontWeight.bold, color: Colors.white)),
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