import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/game%20components/drag_drop_component.dart';
import 'package:verbalautism/components/game%20components/drag_drop_multiple_objects_component.dart';
import 'package:verbalautism/components/game%20components/tap_component.dart';
import 'package:verbalautism/components/game%20components/tap_multiple_objects_component.dart';
import 'package:verbalautism/features/home/pages/home_page.dart';

class PlacesGame extends StatefulWidget {
  const PlacesGame({
    required this.selectedPlace,
    super.key
  });

  final String selectedPlace;

  @override
  State<PlacesGame> createState() => _PlacesGameState();
}

class _PlacesGameState extends State<PlacesGame> {
  // List
  late List<String> places;
  late List<String> assetLinkPlaces;

  // Variables
  int displaySteps = 1;
  int totalSteps = 1;
  int round = 1;
  final int maxSteps = 30;
  bool isPaused = false;

  // Random
  final random = Random();
  late int randomNumber;
  late int randomNumber2;
  late int randomNumber3;
  late int correctIndex;
  late List<String> wrongPlaces;

  @override
  void initState() {
    places = [
      "Airport",
      "Fire Station",
      "Grocery Store",
      "Hospital",
      "Library",
      "Mall",
      "Police Station",
      "Post Office",
      "School"
    ];

    assetLinkPlaces = [
      "Airport",
      "fire_station",
      "grocery_store",
      "Hospital",
      "Library",
      "Mall",
      "police_station",
      "post_office",
      "school"
    ];

    if(widget.selectedPlace.isNotEmpty) {
      correctIndex = places.indexOf(widget.selectedPlace);
      randomNumber = correctIndex;

      if(correctIndex == -1) {
        randomNumber = random.nextInt(places.length);
        correctIndex = randomNumber;
      }
    } else {
      randomNumber = random.nextInt(places.length);
      correctIndex = randomNumber;
    }
    super.initState();
  }

  void setOneWrongNumber(){

    randomNumber2 = random.nextInt(places.length);

    while(randomNumber2 == randomNumber){
      randomNumber2 = random.nextInt(places.length);
    }
    
    wrongPlaces = [assetLinkPlaces[randomNumber2].toLowerCase()];
  }

  void setTwoWrongNumbers(){
    randomNumber2 = random.nextInt(places.length);
    randomNumber3 = random.nextInt(places.length);

    while(randomNumber == randomNumber2 || randomNumber == randomNumber3 || randomNumber2 == randomNumber3){
      randomNumber2 = random.nextInt(places.length);
      randomNumber3 = random.nextInt(places.length);
    }

    wrongPlaces = [assetLinkPlaces[randomNumber2].toLowerCase(), assetLinkPlaces[randomNumber3].toLowerCase()];
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

      // Check round 2
      if(totalSteps >= 10 && totalSteps < 20){
        displaySteps = totalSteps % 10;
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
            backgroundColor: const Color.fromARGB(255, 33, 150, 243), // Blue background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Soft edges
            ),
            title: Text("Exercise Complete!", style: GoogleFonts.ubuntu(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button color
                  foregroundColor: const Color.fromARGB(255, 33, 150, 243), // Text color
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
                  backgroundColor: Colors.white, // Button color
                  foregroundColor: const Color.fromARGB(255, 33, 150, 243), // Text color
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

  @override
  Widget build(BuildContext context) {
    
    Widget currentActivity;
    
    if (totalSteps % 2 == 1 && totalSteps <= 10) {
      currentActivity = TapComponent(onCompleted: nextStep, assetLink: assetLinkPlaces[randomNumber].toLowerCase(), mainData: places[correctIndex], onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/places_images/", objectVariation: "Place",);
    } 
    else if (totalSteps % 2 == 0 && totalSteps <= 10) {
      currentActivity = DragDropComponent(onCompleted: nextStep, assetLink: assetLinkPlaces[randomNumber].toLowerCase(), mainData: places[correctIndex], onCorrectAction: triggerCorrectFlash, totalSteps: totalSteps, directory: "assets/places_images/", objectVariation: "Place",);
    } 
    else if(totalSteps % 2 == 1 && totalSteps >= 10){
      currentActivity = TapMultipleObjectsComponent(onCompleted: nextStep, correctAssetLink: assetLinkPlaces[correctIndex].toLowerCase(), wrongAssetLinks: wrongPlaces, mainData: places[correctIndex], onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/places_images/", objectVariation: "Place",);
    }
    else {
      currentActivity = DragDropMultipleObjectsComponent(onCompleted: nextStep, correctAssetLinks: assetLinkPlaces[correctIndex].toLowerCase(), wrongAssetLinks: wrongPlaces, mainData: places[correctIndex], onCorrectAction: triggerCorrectFlash, onIncorrectAction: triggerIncorrectFlash, directory: "assets/places_images/", objectVariation: "Place",);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(child: Text("Place", style: GoogleFonts.ubuntu(fontSize:24, fontWeight: FontWeight.bold, color: Colors.white))),
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