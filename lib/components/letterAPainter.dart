import 'package:flutter/material.dart';

class LetterAPainter extends CustomPainter{

  final int stepNumber;
  final int totalSteps = 3;

  LetterAPainter({
    required this.stepNumber,
  });

  @override
  void paint(Canvas canvas, Size size){
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.005;

    // Draw Letter
    drawLetter(canvas, size, paint);

    // Draw first dashed lines inside the 'A'
    drawDashedLine(canvas, Offset(size.width * 0.3, size.height * 0.88), Offset(size.width * 0.5, size.height * 0.2), paint);
    // drawDashedLine(canvas, Offset(size.width * 0.55, size.height * 0.55), Offset(size.width * 0.4, size.height * 0.9), paint);
    // drawDashedLine(canvas, Offset(size.width * 0.5, size.height * 0.3), Offset(size.width * 0.5, size.height * 0.1), paint);
  }

  void drawLetter(Canvas canvas, Size size, Paint paint){
        Path outerPath = Path()
      // Start at the bottom left of the 'A'
      ..moveTo(size.width * 0.25, size.height * 0.9)
      // Line to the top point of the 'A'
      ..lineTo(size.width * 0.5, size.height * 0.1)
      // Line to the bottom right of the 'A'
      ..lineTo(size.width * 0.75, size.height * 0.9)
      // Line to the middle right of the 'A'
      ..lineTo(size.width * 0.6, size.height * 0.9)
      // Line to the inner right intersection
      ..lineTo(size.width * 0.55, size.height * 0.65)
      // Line to the inner left intersection
      ..lineTo(size.width * 0.45, size.height * 0.65)
      // Line to the middle left of the 'A'
      ..lineTo(size.width * 0.4, size.height * 0.9)
      // Close the path to the starting point
      ..close();

    Path innerPath = Path()
      // Start at the bottom left of the inner triangle
      ..moveTo(size.width * 0.45, size.height * 0.55)
      // Line to the top point of the inner triangle
      ..lineTo(size.width * 0.5, size.height * 0.3)
      // Line to the bottom right of the inner triangle
      ..lineTo(size.width * 0.55, size.height * 0.55)
      // Close the path to the starting point
      ..close();

    canvas.drawPath(outerPath, paint);
    canvas.drawPath(innerPath, paint);
  }

  void drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashWidth = 5.0;
    const double dashSpace = 6.0;
    double distance = (p2 - p1).distance;
    int dashCount = (distance / (dashWidth + dashSpace)).floor();
    Offset direction = Offset(
      (p2.dx - p1.dx) / distance,
      (p2.dy - p1.dy) / distance,
    );

    for (int i = 0; i < dashCount; ++i) {
      double start = i * (dashWidth + dashSpace);
      Offset offset = direction * start;
      canvas.drawLine(p1 + offset, p1 + offset + direction * dashWidth, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}