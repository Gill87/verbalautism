import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DragAnimation extends StatefulWidget {
  const DragAnimation({super.key});

  @override
  State<DragAnimation> createState() => _DragAnimationState();
}

class _DragAnimationState extends State<DragAnimation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.asset(
        "assets/lottie_animations/drag.json",
        width: 125,
        height: 125,
      ),
    );
  }
}