import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/correct_animation.dart';
import 'package:verbalautism/components/incorrect_animation.dart';

class DragDropMultipleLettersComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String correctLetterLink;
  final List<String> wrongLetterLinks; // Can be 1 or 2 wrong letters
  final String letter;

  const DragDropMultipleLettersComponent({
    super.key,
    required this.onCompleted,
    required this.correctLetterLink,
    required this.wrongLetterLinks,
    required this.letter,
  });

  @override
  State<DragDropMultipleLettersComponent> createState() => _DragDropMultipleLettersComponentState();
}

class _DragDropMultipleLettersComponentState extends State<DragDropMultipleLettersComponent> with SingleTickerProviderStateMixin{
  bool imageDropped = false;
  late List<String> allLetterLinks;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    allLetterLinks = [widget.correctLetterLink, ...widget.wrongLetterLinks];
    allLetterLinks.shuffle(); // Randomize order
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true); // makes it float up and down

    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _showCorrectAnimation() {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: CorrectAnimation(),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onCompleted();
      }
    });
  }


  void _showIncorrectAnimation() {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: IncorrectAnimation(),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();      }
    });
  }

  void _handleDrop(DragTargetDetails<String> details) {
    if (details.data == widget.correctLetterLink) {
      setState(() {
        imageDropped = true;
      });
      _showCorrectAnimation();
    } else {
      _showIncorrectAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.97,
      child: Column(
        children: [
          Text(
            "Drag and Drop the Letter ${widget.letter}",
            style: GoogleFonts.ubuntu(fontSize: 40, color: Colors.white),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...allLetterLinks.map((letter) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: _buildDraggable(letter),
                  )),
              const SizedBox(width: 50),
              _buildDragTarget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDraggable(String letterLink) {

    // Define letter image
    final svg = SvgPicture.asset(
      'assets/abc_images/$letterLink.svg',
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.3,
      fit: BoxFit.contain,
    );

    final animatedSvg = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: child,
        );
      },
      child: svg,
    );

    return Draggable<String>(
      data: letterLink,

      // The widget being dragged
      feedback: Material(
        color: Colors.transparent,  // no background
        child: animatedSvg,                // same as child -> no offset
      ),

      // What is shown in the original spot when dragging is occuring (in this case invisible lettter)
      childWhenDragging: Opacity(
        opacity: 0.0,
        child: animatedSvg,
      ),

      // 👇 Stop floating when drag starts
      onDragStarted: () {
        _controller.stop();
      },

      // If correct image dropped in
      child: imageDropped && letterLink == widget.correctLetterLink
          ? const SizedBox.shrink()
          : animatedSvg,

      // If image not dropped in, resume floating animation
      onDragEnd: (details) {
        if (mounted && !imageDropped) {
          _controller.repeat(reverse: true);
        }
      },

    );
  }


  Widget _buildDragTarget() {
    return DragTarget<String>(
      onAcceptWithDetails: _handleDrop,
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(40),
          ),
          child: imageDropped
              ? SvgPicture.asset(
                  'assets/abc_images/${widget.correctLetterLink}.svg',
                  // width: MediaQuery.of(context).size.width * 0.2,
                  // height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.contain,
              )
              : Center(
                  child: Text(
                    "Drop Here",
                    style: GoogleFonts.ubuntu(fontSize: 30),
                  ),
                ),
        );
      },
    );
  }
}
