import 'package:flutter/material.dart';

class LowercaseActivity extends StatefulWidget {
  const LowercaseActivity({super.key});

  @override
  State<LowercaseActivity> createState() => _LowercaseActivityState();
}

class _LowercaseActivityState extends State<LowercaseActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lowercase Letters"),
      ),

      
    );
  }
}