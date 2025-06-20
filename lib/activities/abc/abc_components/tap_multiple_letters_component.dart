import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/correct_animation.dart';

class TapMultipleLettersComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String correctLetterLink;
  final List<String> wrongLetterLinks; // 1 or 2 wrong letters
  final String letter;

  const TapMultipleLettersComponent({
    super.key,
    required this.onCompleted,
    required this.correctLetterLink,
    required this.wrongLetterLinks,
    required this.letter,
  });

  @override
  State<TapMultipleLettersComponent> createState() => _TapMultipleLettersComponentState();
}

class _TapMultipleLettersComponentState extends State<TapMultipleLettersComponent> {
  late List<String> allLetterLinks;

  @override
  void initState() {
    super.initState();
    allLetterLinks = [widget.correctLetterLink, ...widget.wrongLetterLinks];
    allLetterLinks.shuffle(); // Randomize their order
  }

  void _handleTap(String tappedLetter) {
    if (tappedLetter == widget.correctLetterLink) {
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

  void _showCorrectAnimation() {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return const Center(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          Text(
            "Tap the Letter ${widget.letter}",
            style: GoogleFonts.ubuntu(fontSize: 40, color: Colors.white),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: allLetterLinks.map((letter) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _handleTap(letter),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow, // Background color for each letter
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    child: Transform.scale(
                      scale: 1.5,
                      child: SvgPicture.asset(
                        'assets/abc_images/$letter.svg',
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    ),
  );
}}
