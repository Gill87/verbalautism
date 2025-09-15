import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/numbers/games_pages/numbers_game.dart';
import 'package:verbalautism/components/animations/animated_card.dart';

class NumberSelectionPage extends StatelessWidget {
  final String rangeLabel;
  final int min;
  final int max;
  
  const NumberSelectionPage({
    super.key, 
    required this.rangeLabel, 
    required this.min, 
    required this.max
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "Select Number ($rangeLabel)",
          style: GoogleFonts.ubuntu(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
            minWidth: MediaQuery.of(context).size.width,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // Random and Shuffle buttons
              _buildNumberCard(
                context,
                number: "Random",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NumbersGame(
                        min: min,
                        max: max,
                        selectedNumber: -1, // -1 indicates random
                      ),
                    ),
                  );
                },
                isRandom: true,
              ),

              const SizedBox(height: 20),
              
              // Numbers grid
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: List.generate(max - min + 1, (index) {
                  int number = min + index;
                  return _buildNumberCard(
                    context,
                    number: number.toString(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NumbersGame(
                            min: min,
                            max: max,
                            selectedNumber: number,
                          ),
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

  Widget _buildNumberCard(BuildContext context,
      {required String number, required VoidCallback onTap, bool isRandom = false}) {
    return AnimatedCard(
      onTap: onTap,
      child: Card(
        elevation: 8,
        color: isRandom ? Colors.orange : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: isRandom ? 100 : 125,
          height: isRandom ? 75 : 125,
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.ubuntu(
                fontSize: isRandom ? 18 : 36,
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