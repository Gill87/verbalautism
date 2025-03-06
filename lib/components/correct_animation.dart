import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CorrectAnimation extends StatelessWidget {
  const CorrectAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Lottie.network(
        'https://lottie.host/fcaa6bd8-f5ca-4407-a215-5bce25c907a8/JuXqD04AMD.json',
        repeat: false,
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.4,

      )
    );
  }
}