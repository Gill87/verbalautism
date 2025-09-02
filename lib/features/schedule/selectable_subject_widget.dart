import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectableSubjectWidget extends StatelessWidget {
  final Function()? tapFunction;
  final String text;
  final AssetImage image1;
  final double height;
  final double width;
  final Color color;
  final bool isSelectionMode;
  final bool isSelected;
  final String activityName;

  const SelectableSubjectWidget({
    super.key,
    required this.tapFunction,
    required this.text,
    required this.image1,
    this.width = double.infinity,
    this.height = double.infinity,
    this.color = Colors.black,
    this.isSelectionMode = false,
    this.isSelected = false,
    required this.activityName,
  });

  bool isSmallWidth(BuildContext context) =>
      MediaQuery.of(context).size.width <= 740;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapFunction,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Stack(
            children: [
              // Main container
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                  image: DecorationImage(image: image1, fit: BoxFit.cover),
                  border: Border.all(
                    width: isSelectionMode && isSelected ? 3 : 1,
                    color: isSelectionMode && isSelected ? Colors.green : Colors.black,
                  ),
                ),
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 100,
                  color: Colors.white38.withOpacity(0.8),
                  child: Text(
                    text,
                    style: GoogleFonts.ubuntu(
                      fontSize: isSmallWidth(context) ? 12 : 15,
                      color: Colors.black
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Selection overlay
              if (isSelectionMode)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Icon(
                      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                      color: isSelected ? Colors.green : Colors.grey,
                      size: 24,
                    ),
                  ),
                ),

              // Dimming overlay when not selected in selection mode
              if (isSelectionMode && !isSelected)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}