import 'package:flutter/material.dart';

class ShapesGame extends StatefulWidget {
  const ShapesGame({
    super.key,
    required this.selectedShape,
  });

  final String selectedShape;

  @override
  State<ShapesGame> createState() => _ShapesGameState();
}

class _ShapesGameState extends State<ShapesGame> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}