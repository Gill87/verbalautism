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

