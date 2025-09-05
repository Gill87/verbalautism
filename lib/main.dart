import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:verbalautism/components/audio%20services/tts_service.dart';
import 'package:verbalautism/myapp.dart';
import 'firebase_options.dart';

// Make sure to turn write to false in firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize TTS Service
  final tts = TtsService();
  await tts.init(); 

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}