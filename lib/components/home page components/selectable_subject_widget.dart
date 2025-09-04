import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectableSubjectWidget extends StatefulWidget {
  final Function()? tapFunction;
  final String text;
  final ImageProvider image; // pass AssetImage/NetworkImage/etc.
  final double height;
  final double width;
  final Color color; // keep for outer border tint if you want
  final bool isSelectionMode;
  final bool isSelected;
  final String activityName;

  const SelectableSubjectWidget({
    super.key,
    required this.tapFunction,
    required this.text,
    required this.image,
    this.width = double.infinity,
    this.height = double.infinity,
    this.color = Colors.black,
    this.isSelectionMode = false,
    this.isSelected = false,
    required this.activityName,
  });

  @override
  State<SelectableSubjectWidget> createState() => _SelectableSubjectWidgetState();
}

class _SelectableSubjectWidgetState extends State<SelectableSubjectWidget> {
  bool _isHovered = false;
  bool _isPressed = false;

  late final Image _bgImage;

  @override
  void initState() {
    super.initState();
    // Reuse the same Image widget to avoid stream resets/flicker.
    _bgImage = Image(
      image: widget.image,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      // Optional: helps on web when scaling
      filterQuality: FilterQuality.medium,
    );
    // Optional: ensure it’s decoded before first paint
    // (safe even for AssetImage)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(widget.image, context);
    });
  }

  bool isSmallWidth(BuildContext context) =>
      MediaQuery.of(context).size.width <= 740;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.tapFunction?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            scale: _isPressed ? 0.95 : (_isHovered ? 1.05 : 1.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              // Only animate border/shadow here; NOT the image.
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // keep transparent so no black flash
                color: Colors.transparent,
                border: Border.all(
                  width: widget.isSelectionMode && widget.isSelected ? 3 : 1,
                  color: widget.isSelectionMode && widget.isSelected
                      ? Colors.green
                      : Colors.black,
                ),
                boxShadow: _isHovered
                    ? [const BoxShadow(blurRadius: 8, offset: Offset(0, 4), color: Colors.black26)]
                    : const [],
              ),
              clipBehavior: Clip.hardEdge, // clip children to rounded corners
              child: Stack(
                children: [
                  // Background image isolated from animation
                  Positioned.fill(
                    child: _bgImage,
                  ),

                  // Dimming overlay when not selected in selection mode
                  if (widget.isSelectionMode && !widget.isSelected)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 120),
                          opacity: 0.3,
                          child: Container(color: Colors.black),
                        ),
                      ),
                    ),

                  // Bottom label
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 100,
                      color: Colors.white38.withOpacity(0.8),
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                          fontSize: isSmallWidth(context) ? 12 : 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  // Selection checkmark
                  if (widget.isSelectionMode)
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
                          widget.isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                          color: widget.isSelected ? Colors.green : Colors.grey,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
