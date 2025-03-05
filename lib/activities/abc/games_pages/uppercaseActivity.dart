import 'package:flutter/material.dart';

class UppercaseActivity extends StatefulWidget {
  const UppercaseActivity({super.key});

  @override
  State<UppercaseActivity> createState() => _UppercaseActivityState();
}

class _UppercaseActivityState extends State<UppercaseActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uppercase Letters"),
      ),

    );
  }
}