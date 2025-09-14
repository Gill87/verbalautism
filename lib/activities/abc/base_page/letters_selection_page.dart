// New Letter Selection Page
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_lowercase_game.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_uppercase_game.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_mixed_game.dart'; // ✅ import mixed game
import 'package:verbalautism/components/animations/animated_card.dart';

class LetterSelectionPage extends StatelessWidget {
  final String caseType;

  const LetterSelectionPage({super.key, required this.caseType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "Select $caseType Letter",
          style: GoogleFonts.ubuntu(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_images/colorful_bg.webp"),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Random option card
                  _buildLetterCard(
                    context,
                    letter: "Random",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            if (caseType == "Uppercase") {
                              return const AbcUppercaseGame(selectedLetter: "");
                            } else if (caseType == "Lowercase") {
                              return const AbcLowercaseGame(selectedLetter: "");
                            } else {
                              return const AbcMixedGame(selectedLetter: "");
                            }
                          },
                        ),
                      );
                    },
                    isRandom: true,
                  ),

                  // Shuffle option card
                  _buildLetterCard(
                    context,
                    letter: "Shuffle",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            if (caseType == "Uppercase") {
                              return const AbcUppercaseGame(selectedLetter: "Shuffle");
                            } else if (caseType == "Lowercase") {
                              return const AbcLowercaseGame(selectedLetter: "Shuffle");
                            } else {
                              return const AbcMixedGame(selectedLetter: "Shuffle");
                            }
                          },
                        ),
                      );
                    },
                    isRandom: true,
                  ),
                ]
              ),

              const SizedBox(height: 20),

              // Letter grid
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: _buildLetterList().map((letter) {
                  return _buildLetterCard(
                    context,
                    letter: letter,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            if (caseType == "Uppercase") {
                              return AbcUppercaseGame(selectedLetter: letter);
                            } else if (caseType == "Lowercase") {
                              return AbcLowercaseGame(selectedLetter: letter);
                            } else {
                              return AbcMixedGame(selectedLetter: letter);
                            }
                          },
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the list of letters depending on caseType
  List<String> _buildLetterList() {
    if (caseType == "Uppercase") {
      return List.generate(26, (i) => String.fromCharCode(65 + i));
    } else if (caseType == "Lowercase") {
      return List.generate(26, (i) => String.fromCharCode(97 + i));
    } else {
      // Mixed: Aa, Bb, Cc ...
      return List.generate(
        26,
        (i) =>
            "${String.fromCharCode(65 + i)}${String.fromCharCode(97 + i)}",
      );
    }
  }

  Widget _buildLetterCard(BuildContext context,
      {required String letter,
      required VoidCallback onTap,
      bool isRandom = false}) {
    return AnimatedCard(
      onTap: onTap,
      child: Card(
        elevation: 8,
        color: isRandom ? Colors.orange : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          width: isRandom ? 100 : 80,
          height: isRandom ? 75 : 80,
          child: Center(
            child: Text(
              letter,
              style: GoogleFonts.ubuntu(
                fontSize: isRandom ? 18 : 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
