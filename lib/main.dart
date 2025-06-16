// TODO: Audio for "Tap the letter, trace the letter, yes, no help, hello, goodbye, etc"
// TODO: Higher quality letter images
// TODO: Add verbal to logo name (higher quality as well)
// TODO: Implement money animation in game (+1 for incorrect, +5 for correct)
// TODO: Also have nicer correct and incorrect animations
// TODO: Higher quality background images
// TODO: Add app bar in game menus and base page with music toggle and cash being shown
// TODO: Add left bar with goodbye, hello, etc. 


// Once all this is done then we can focus on
// TODO: Making sure app works well on many different device sizes

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:verbalautism/myapp.dart';
import 'firebase_options.dart';

// Make sure to turn write to false in firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}