import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DragAnimation extends StatelessWidget {
  const DragAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.asset(
        "assets/lottie_animations/drag.json",
        width: 75,
        height: 75,
      ),
    );
  }
}