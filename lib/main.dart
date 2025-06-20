// TODO: Higher quality letter images (svg)
// TODO: Create Universal Color Theme File to fix all the hard coded colors
// TODO: Implement more game logic and beautiful animations in abc game
// TODO: Audio for "Tap the letter, trace the letter, yes, no help, hello, goodbye, etc"
// TODO: Add those audio buttons to all pages in the app
// TODO: Add verbal to logo name (higher quality as well)


// TODO: Implement money animation in game (+1 for incorrect, +5 for correct)
// TODO: Add app bar in game menus and base page with music toggle and cash being shown


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