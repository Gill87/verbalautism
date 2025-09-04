import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButton extends StatefulWidget {

  final Function()? tapFunction;
  final String text;

  const LoginButton({super.key, required this.tapFunction, required this.text});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {

  bool _isHovered = false;
  bool _isPressed = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => {
        setState(() => _isPressed = false),
        widget.tapFunction?.call()
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: _isPressed ? 0.95 : (_isHovered ? 1.05 : 1.0), // press = shrink, hover = enlarge
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:Colors.black,
              borderRadius: BorderRadius.circular(8),
              ),
            child: Center(
              child: Text(
                widget.text,
                style: GoogleFonts.ubuntu(fontSize: 24, color: Colors.white),
                ),
            )
          ),
        ),
      ),
    );
  }
}