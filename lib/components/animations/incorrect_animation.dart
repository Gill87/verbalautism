import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IncorrectAnimation extends StatelessWidget {
  const IncorrectAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.asset(
        "assets/lottie_animations/oops.json",
        width: 300,
        height: 300,
        repeat: false,
      ),
    );
  }
}