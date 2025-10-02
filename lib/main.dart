import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:verbalautism/myapp.dart';
import 'firebase_options.dart';
import 'package:web/web.dart' as web;
// Make sure to turn write to false in firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force the tab title
  web.document.title = "VERBAL Autism";

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
      
  runApp(MyApp());
}