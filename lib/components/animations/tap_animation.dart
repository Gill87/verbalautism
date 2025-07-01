import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TapAnimation extends StatefulWidget {
  const TapAnimation({super.key});

  @override
  State<TapAnimation> createState() => _TapAnimationState();
}

class _TapAnimationState extends State<TapAnimation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.asset(
        "assets/lottie_animations/tap.json",
        width: 125,
        height: 125,
      ),
    );
  }
}