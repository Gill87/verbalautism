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
import 'package:verbalautism/components/game%20components/trace_component.dart';
import 'package:verbalautism/components/game_loading_indicator.dart';
import 'package:verbalautism/features/home/pages/home_page.dart';

class NumbersGame extends StatefulWidget {
  final int min;
  final int max;
  final int selectedNumber;

  const NumbersGame({
    required this.min,
    required this.max,
    required this.selectedNumber,
    super.key
  });

  @override
  State<NumbersGame> createState() => _NumbersGameState();
}

class _NumbersGameState extends State<NumbersGame> {
  
  // List
  late List <int> numbers;
  List<int> stepDurations = []; // store all durations (in seconds)
  List<int> shuffleNumberList = [];

  List<int> numberQueue = [];
  int queueIndex = 0;

  // Variables
  int incorrectAnswer = 0;
  int correctAnswer = 0;
  int displaySteps = 1;
  int totalSteps = 1;
  int round = 1;
  int gamesPlayedCount = 0;
  final int maxSteps = 30;
  bool isPaused = false;
  bool isInitializing = false;
  bool randomize = false;
  DateTime? stepStartTime;
  double durationAvg = 0;
  Timer? stepTimer;

  // Random Object
  Random random = Random();

  // Random Number Variables
  late int randomNumber;
  late int randomNumber2;
  late int randomNumber3;
  late int correctIndex;
  late List <String> wrongNumbers;

  
  @override
  void initState() {
    super.initState();
    numbers = List.generate(
      (widget.max - widget.min + 1), // length
      (index) => widget.min + index, // generate
    );
    initializeGame();
  }

  Future<void> populateShuffleList() async {
    setState(() {
      isInitializing = true;
    });

    shuffleNumberList = await fetchShuffleNumbers();
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      isInitializing = false;
    });
  }

  void _assignFromQueue() {
    if (numberQueue.isEmpty || queueIndex >= numberQueue.length) {
      numberQueue = List.from(numbers)..shuffle(random);
      queueIndex = 0;
    }

    print("Queue: $numberQueue");

    int chosenNumber = numberQueue[queueIndex];
    randomNumber = numbers.indexOf(chosenNumber);
    correctIndex = randomNumber;

    queueIndex++;
  }

  void initializeGame() async {

    ++gamesPlayedCount;

    // Initialize the queue first if it's empty
    if (numberQueue.isEmpty) {
      numberQueue = List.from(numbers)..shuffle(random);
      queueIndex = 0;
    }

    setState(() {
      isInitializing = true;
    });

    if(widget.selectedNumber == -2 && gamesPlayedCount % 3 == 0){
      await populateShuffleList();
      print("Shuffle Number List before removing: $shuffleNumberList");

      // Only remove items if queueIndex is valid and within bounds
      if (queueIndex > 0 && queueIndex - 1 < numberQueue.length) {
        shuffleNumberList.remove(numberQueue[queueIndex - 1]); // Previous
      }
      if (queueIndex < numberQueue.length) {
        shuffleNumberList.remove(numberQueue[queueIndex]); // Current
      }
      
      print("Shuffle Word List after removing: $shuffleNumberList");
      
      if (shuffleNumberList.isNotEmpty) {
        int chosenTerm = shuffleNumberList[random.nextInt(shuffleNumberList.length)];
        randomNumber = numbers.indexOf(chosenTerm);
        if (randomNumber != -1) {
          correctIndex = randomNumber;
          print("Using shuffle word: $chosenTerm");
        } else {
          // If the chosen term is not in shapes list, fall back to queue
          _assignFromQueue();
        }
      } else {
        print("Shuffle word list is empty, using queue");
        _assignFromQueue();
      }

    } else if (widget.selectedNumber >= 0 && 
              widget.selectedNumber != -2 && 
              !randomize) {
      // Use specific selected shapes
      randomNumber = numbers.indexOf(widget.selectedNumber);
      if (randomNumber == -1) {
        _assignFromQueue();
      } else {
        correctIndex = randomNumber;
      }
    } else {
      // Use queue for random selection
      _assignFromQueue();
    }

    setState(() {
      isInitializing = false;
    });
    
    // Ensure UI updates and start timer
    if (mounted) {
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        startStepTimer();
      });
    }
  }

  @override
  void dispose(){
    super.dispose();
    stepTimer?.cancel();
  }

  Future<List<int>> fetchShuffleNumbers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    // read all lowercaseLettersReports for the user
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("numbersReports")
        .get();

    Set<int> shuffleNumberSet = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final int incorrect = data["incorrect"] ?? 0;
      final String strNumber = data["word"] ?? -2;

      final int number = int.parse(strNumber);

      if (incorrect > 2 && number != -2) {
        shuffleNumberSet.add(number);
      }
    }

    return shuffleNumberSet.toList();
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

  int generateRandomNumber(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  void setOneWrongNumber(){
    randomNumber2 = generateRandomNumber(widget.min, widget.max);

    while(randomNumber2 == randomNumber){
      randomNumber2 = generateRandomNumber(widget.min, widget.max);
    }
    
    wrongNumbers = ["Number_${numbers[randomNumber2 - widget.min]}"];
  }

  void setTwoWrongNumbers(){
    randomNumber2 = generateRandomNumber(widget.min, widget.max);
    randomNumber3 = generateRandomNumber(widget.min, widget.max);

    while(randomNumber == randomNumber2 || randomNumber == randomNumber3 || randomNumber2 == randomNumber3){
      randomNumber2 = generateRandomNumber(widget.min, widget.max);
      randomNumber3 = generateRandomNumber(widget.min, widget.max);
    }

    wrongNumbers = ["Number_${numbers[randomNumber2 - widget.min]}", "Number_${numbers[randomNumber3 - widget.min]}"];
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
  
    // Reset Incorrect Answers
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
          gameType: "numbers",
          correct: correctAnswer,
          incorrect: 0,
          roundNumber: round,
          averageDuration: calculateAverageDuration(),
          word: numbers[correctIndex].toString(),
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
            gameType: "numbers",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: numbers[correctIndex].toString(),
          );
          repeatRound(2);
        } else {
          uploadRoundResult(
            gameType: "numbers",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: numbers[correctIndex].toString(),
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
            gameType: "numbers",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: numbers[correctIndex].toString(),
          );
          repeatRound(3);
        } else {
          uploadRoundResult(
            gameType: "numbers",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: numbers[correctIndex].toString(),
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
                initializeGame(); // reset the game state
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
    print("✅ Round result uploaded for $gameType");
  }

  @override
  Widget build(BuildContext context) {
    if (isInitializing) {
      return GameLoadingIndicator(titleHeader: "Numbers ${widget.min} - ${widget.max}"); 
    }
    
    Widget currentActivity;
    
    if (totalSteps % 3 == 1 && totalSteps <= 10) {
      currentActivity = TapComponent(onCompleted: nextStep, assetLink: "Number_${numbers[correctIndex]}", mainData: numbers[correctIndex].toString(), onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/number_images/", objectVariation: "Number",);
    } 
    else if (totalSteps % 3 == 2 && totalSteps < 10) {
      currentActivity = DragDropComponent(onCompleted: nextStep, assetLink: "Number_${numbers[correctIndex]}", mainData: numbers[correctIndex].toString(), onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/number_images/", objectVariation: "Number",);
    } 
    else if(totalSteps % 3 == 0 && totalSteps < 10){
      currentActivity = TraceComponent(onCompleted: nextStep, mainData: numbers[correctIndex].toString(), onCorrectAction: triggerCorrectFlash, objectVariation: "Number",);
    } 
    else if(totalSteps % 3 == 1 && totalSteps >= 10){
      currentActivity = TapMultipleObjectsComponent(onCompleted: nextStep, correctAssetLink: "Number_${numbers[correctIndex]}", wrongAssetLinks: wrongNumbers, mainData: numbers[correctIndex].toString(), onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/number_images/", objectVariation: "Number",);
    }
    else if(totalSteps % 3 == 2 && totalSteps >= 10){
      currentActivity = DragDropMultipleObjectsComponent(onCompleted: nextStep, correctAssetLinks: "Number_${numbers[correctIndex]}", wrongAssetLinks: wrongNumbers, mainData: numbers[correctIndex].toString(), onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/number_images/", objectVariation: "Number",);
    } 
    else {
      currentActivity = TraceComponent(onCompleted: nextStep, mainData: numbers[correctIndex].toString(), onCorrectAction: triggerCorrectFlash, objectVariation: "Number",);
    }
    
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Numbers ${widget.min} - ${widget.max}", style: GoogleFonts.ubuntu(fontSize:24, fontWeight: FontWeight.bold, color: Colors.white)),
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