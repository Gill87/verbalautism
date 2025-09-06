import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/abc/base_page/letters_selection_page.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_mixed_game.dart';
import 'package:verbalautism/components/image_activity_card.dart';

class AbcBasePage extends StatefulWidget {
  const AbcBasePage({super.key});

  @override
  State<AbcBasePage> createState() => _AbcBasePageState();
}

class _AbcBasePageState extends State<AbcBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "ABC",
          style: GoogleFonts.ubuntu(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
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
            minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          ),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                ImageActivityCard(
                  label: "Uppercase",
                  image: "assets/abc_images/Uppercase_A.svg",
                  onTap: onTapCard(
                    context,
                    "Uppercase",
                  ),
                ),
                ImageActivityCard(
                  label: "Lowercase",
                  image: "assets/abc_images/Lowercase_A.svg",
                  onTap: onTapCard(
                    context,
                    "Lowercase",
                  ),
                ),
                ImageActivityCard(
                  label: "Mixed",
                  image: "assets/abc_images/MixedLettersImage.svg",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AbcMixedGame()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Updated onTapCard function
void Function() onTapCard(BuildContext context, String label) {
  return () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LetterSelectionPage(caseType: label),
      ),
    );
  };
}