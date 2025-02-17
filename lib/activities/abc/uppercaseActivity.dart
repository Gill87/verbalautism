import 'package:flutter/material.dart';
import 'package:whiteboard/whiteboard.dart';

class UppercaseActivity extends StatefulWidget {
  const UppercaseActivity({super.key});

  @override
  State<UppercaseActivity> createState() => _UppercaseActivityState();
}

void doNothing(){
  
}

class _UppercaseActivityState extends State<UppercaseActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uppercase Letters"),
      ),
      body: const Stack(
        children: [
          Center(child: Image(image: AssetImage("lib/images/UppA1.webp"))),

          WhiteBoard(
            backgroundColor: Colors.transparent,
            strokeColor: Colors.green,
            strokeWidth: 25,
          ),
        ],
      )
    );
  }
}