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
import 'package:verbalautism/features/home/pages/home_page.dart';

class SightWordGame extends StatefulWidget {
  const SightWordGame({
    super.key,
    required this.selectedSightWord,
  });

  final String selectedSightWord;

  @override
  State<SightWordGame> createState() => _SightWordGameState();
}

class _SightWordGameState extends State<SightWordGame> {
  // List
  late List<String> sightWords;
  List<int> stepDurations = []; // store all durations (in seconds)

  // Variables
  bool alreadyGotIncorrect = false;
  int correctAnswer = 0;
  int incorrectAnswer = 0;
  int displaySteps = 1;
  int totalSteps = 1;
  int round = 1;
  final int maxSteps = 30;
  bool isPaused = false;
  DateTime? stepStartTime;
  double durationAvg = 0;
  Timer? stepTimer;

  // Random
  final random = Random();
  late int randomNumber;
  late int randomNumber2;
  late int randomNumber3;
  late int correctIndex;
  late List<String> wrongSightWords;

  @override
  void initState() {
    sightWords = [
      "And", "Can", "For", "Is", "It", "Me", "See", "We", "You",
      "By", "Do", "Give", "From", "Go", "Of", "On", "This", "That",
      "Will", "With", "Use", "Help", "Us", "Made", "Or", "Tell"
    ];

    if (widget.selectedSightWord.isNotEmpty) {
      correctIndex = sightWords.indexOf(widget.selectedSightWord);
      randomNumber = correctIndex;

      if (correctIndex == -1) {
        randomNumber = random.nextInt(sightWords.length);
        correctIndex = randomNumber;
      }
    } else {
      randomNumber = random.nextInt(sightWords.length);
      correctIndex = randomNumber;
    }

    super.initState();
  }

  @override
  void dispose() {
    // Clean up any resources
    super.dispose();
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

  void setOneWrongNumber() {
    randomNumber2 = random.nextInt(sightWords.length);

    while (randomNumber2 == randomNumber) {
      randomNumber2 = random.nextInt(sightWords.length);
    }

    wrongSightWords = [sightWords[randomNumber2].toLowerCase()];
  }

  void setTwoWrongNumbers() {
    randomNumber2 = random.nextInt(sightWords.length);
    randomNumber3 = random.nextInt(sightWords.length);

    while (randomNumber == randomNumber2 ||
        randomNumber == randomNumber3 ||
        randomNumber2 == randomNumber3) {
      randomNumber2 = random.nextInt(sightWords.length);
      randomNumber3 = random.nextInt(sightWords.length);
    }

    wrongSightWords = [
      sightWords[randomNumber2].toLowerCase(),
      sightWords[randomNumber3].toLowerCase()
    ];
  }

  void nextRoundDialog(int roundNumber) {
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
  void repeatRoundDialog(int roundNumber) {
    // Pause
    setState(() {
      isPaused = true;
    });

    // Reset Answer Counters
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

  void repeatRound(int roundNumber) {
    if (roundNumber == 2) {
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

  void round2() {
    if (totalSteps == 10) {
      nextRoundDialog(2);
    }
    setOneWrongNumber();
    round = 2;
  }

  void round3() {
    if (totalSteps == 20) {
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
          gameType: "sightWord",
          correct: correctAnswer,
          incorrect: 0,
          roundNumber: round,
          averageDuration: calculateAverageDuration(),
          word: sightWords[correctIndex],
        );
        stepDurations.clear(); // Clear durations for next round
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
            gameType: "sightWord",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: sightWords[correctIndex],
          );
          stepDurations.clear(); // Clear durations for next round
          repeatRound(2);
        } else {
          uploadRoundResult(
            gameType: "sightWord",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: sightWords[correctIndex],
          );
          stepDurations.clear(); // Clear durations for next round
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
            gameType: "sightWord",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: sightWords[correctIndex],
          );
          stepDurations.clear(); // Clear durations for next round
          repeatRound(3);
        } else {
          uploadRoundResult(
            gameType: "sightWord",
            correct: correctAnswer,
            incorrect: incorrectAnswer,
            roundNumber: round,
            averageDuration: calculateAverageDuration(),
            word: sightWords[correctIndex],
          );
        stepDurations.clear(); // Clear durations for next round
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
    if (!alreadyGotIncorrect) {
      ++correctAnswer;
    }
    alreadyGotIncorrect = false;

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
    if (!alreadyGotIncorrect) {
      ++incorrectAnswer;
      alreadyGotIncorrect = true;
    }

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

    print("✅ Round result uploaded for $gameType");
  }
  
  @override
  Widget build(BuildContext context) {
    Widget currentActivity;

    if (totalSteps % 2 == 1 && totalSteps <= 10) {
      // Round 1 Odd Steps → Tap
      currentActivity = TapComponent(
        onCompleted: nextStep,
        assetLink: sightWords[randomNumber].toLowerCase(),
        mainData: sightWords[correctIndex],
        onCorrectAction: triggerCorrectFlash,
        totalSteps: totalSteps,
        directory: "assets/sight_word_images/",
        objectVariation: "Sight Word",
      );
    } else if (totalSteps % 2 == 0 && totalSteps <= 10) {
      // Round 1 Even Steps → Drag & Drop
      currentActivity = DragDropComponent(
        onCompleted: nextStep,
        assetLink: sightWords[randomNumber].toLowerCase(),
        mainData: sightWords[correctIndex],
        onCorrectAction: triggerCorrectFlash,
        totalSteps: totalSteps,
        directory: "assets/sight_word_images/",
        objectVariation: "Sight Word",
      );
    } else if (totalSteps % 2 == 1 && totalSteps >= 10) {
      // Rounds 2 & 3 Odd Steps → Tap Multiple
      currentActivity = TapMultipleObjectsComponent(
        onCompleted: nextStep,
        correctAssetLink: sightWords[correctIndex].toLowerCase(),
        wrongAssetLinks: wrongSightWords,
        mainData: sightWords[correctIndex],
        onCorrectAction: triggerCorrectFlash,
        onIncorrectAction: triggerIncorrectFlash,
        directory: "assets/sight_word_images/",
        objectVariation: "Sight Word",
      );
    } else {
      // Rounds 2 & 3 Even Steps → Drag & Drop Multiple
      currentActivity = DragDropMultipleObjectsComponent(
        onCompleted: nextStep,
        correctAssetLinks: sightWords[correctIndex].toLowerCase(),
        wrongAssetLinks: wrongSightWords,
        mainData: sightWords[correctIndex],
        onCorrectAction: triggerCorrectFlash,
        onIncorrectAction: triggerIncorrectFlash,
        directory: "assets/sight_word_images/",
        objectVariation: "Sight Word",
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
          child: Text(
            "Sight Words",
            style: GoogleFonts.ubuntu(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_images/32442923_7895078.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: containerColor, // Black except for flash
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: !isPaused
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Round: $round",
                        style: GoogleFonts.ubuntu(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Trial: $displaySteps / 10",
                        style: GoogleFonts.ubuntu(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      currentActivity,
                    ],
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }
}
