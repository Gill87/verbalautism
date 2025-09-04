import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CorrectAnimation extends StatelessWidget {
  const CorrectAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Lottie.asset(
        "assets/lottie_animations/correct.json",
        width: 300,
        height: 300,
        repeat: false,
      )
    );
  }
}