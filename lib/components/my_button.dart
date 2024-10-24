import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final Function()? tapFunction;
  final String text;

  const MyButton({super.key, required this.tapFunction, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapFunction,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color:Colors.black,
          borderRadius: BorderRadius.circular(8),
          ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color:Colors.white,
              fontSize: 20,
              ),
            ),
        )
      ),
    );
  }
}