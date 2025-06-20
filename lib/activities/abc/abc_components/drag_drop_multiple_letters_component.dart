import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/correct_animation.dart';

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

class _DragDropMultipleLettersComponentState extends State<DragDropMultipleLettersComponent> {
  bool imageDropped = false;
  late List<String> allLetterLinks;

  @override
  void initState() {
    super.initState();
    allLetterLinks = [widget.correctLetterLink, ...widget.wrongLetterLinks];
    allLetterLinks.shuffle(); // Randomize order
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

  void _handleDrop(DragTargetDetails<String> details) {
    if (details.data == widget.correctLetterLink) {
      setState(() {
        imageDropped = true;
      });
      _showCorrectAnimation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong letter! Try again.'),
          duration: Duration(seconds: 1),
        ),
      );
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
    return Draggable<String>(
      data: letterLink,
      feedback: Opacity(
        opacity: 1,
        child: Transform.translate(
          offset: const Offset(200, 0),
          child: SvgPicture.asset(
            'assets/abc_images/$letterLink.svg',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: SvgPicture.asset(
          'assets/abc_images/$letterLink.svg',
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height * 0.3,
          fit: BoxFit.contain,
        ),
      ),
      child: imageDropped && letterLink == widget.correctLetterLink
          ? const SizedBox(width: 0, height: 0)
          : SvgPicture.asset(
              'assets/abc_images/$letterLink.svg',
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.contain,
          ),
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
