// New Letter Selection Page
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_lowercase_game.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_uppercase_game.dart';

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
          "Select ${caseType} Letter",
          style: GoogleFonts.ubuntu(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_images/32442923_7895078.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Random option card
              _buildLetterCard(
                context,
                letter: "Random",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => caseType == "Uppercase"
                          ? const AbcUppercaseGame(selectedLetter: "")
                          : const AbcLowercaseGame(selectedLetter: ""),
                    ),
                  );
                },
                isRandom: true,
              ),
              const SizedBox(height: 20),
              // Letter grid
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: List.generate(26, (index) {
                  String letter = String.fromCharCode(index + (caseType == "Uppercase" ? 65 : 97));
                  return _buildLetterCard(
                    context,
                    letter: letter,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => caseType == "Uppercase"
                              ? AbcUppercaseGame(selectedLetter: letter)
                              : AbcLowercaseGame(selectedLetter: letter),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetterCard(BuildContext context,
      {required String letter, required VoidCallback onTap, bool isRandom = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      splashColor: Colors.yellow.withOpacity(0.3),
      child: Card(
        elevation: 8,
        color: isRandom ? Colors.orange : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
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
