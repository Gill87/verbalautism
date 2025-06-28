import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String textBoxDetails;
  final bool hideText;
  
  const MyTextField({
    super.key,
    required this.controller,
    required this.textBoxDetails,
    required this.hideText,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: hideText,
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: textBoxDetails,
        ),
      ),
    );
  }
}