import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:verbalautism/components/audio%20services/google_tts.dart';
import 'package:verbalautism/myapp.dart';
import 'firebase_options.dart';

// Make sure to turn write to false in firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final tts = GoogleTTS();
  await tts.init('assets/keys/tts_service.json');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}