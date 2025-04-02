import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CorrectAnimation extends StatelessWidget {
  const CorrectAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Lottie.network(
        'https://lottie.host/b4a90af8-4e69-4372-9146-60eb855bb0ba/ySCUk4ATJ6.json',
        repeat: false,
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.4,

      )
    );
  }
}