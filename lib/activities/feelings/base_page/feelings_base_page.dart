import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/feelings/games_page/feelings_game.dart';
import 'package:verbalautism/components/image_activity_card.dart';

class FeelingsBasePage extends StatefulWidget {
  const FeelingsBasePage({super.key});

  @override
  State<FeelingsBasePage> createState() => _FeelingsBasePageState();
}

class _FeelingsBasePageState extends State<FeelingsBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "Feelings",
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeelingsGame(selectedFeeling: "")),
                    ),
                    child: Text("Random", style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white)),
                  ),

                  const SizedBox(width: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeelingsGame(selectedFeeling: "Shuffle")),
                    ),
                    child: Text("Shuffle", style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    ImageActivityCard(
                      image: "assets/feelings_images/happy.webp",
                      label: "Happy",
                      onTap: onTapCard(context, "Happy"),
                    ),
                    ImageActivityCard(
                      image: "assets/feelings_images/sad.webp",
                      label: "Sad",
                      onTap: onTapCard(context, "Sad"),
                    ),
                    ImageActivityCard(
                      image: "assets/feelings_images/angry.webp",
                      label: "Angry",
                      onTap: onTapCard(context, "Angry"),
                    ),
                    ImageActivityCard(
                      image: "assets/feelings_images/curious.webp",
                      label: "Curious",
                      onTap: onTapCard(context, "Curious"),
                    ),
                    ImageActivityCard(
                      image: "assets/feelings_images/sick.webp",
                      label: "Sick",
                      onTap: onTapCard(context, "Sick"),
                    ),
                    ImageActivityCard(
                      image: "assets/feelings_images/surprised.webp",
                      label: "Surprised",
                      onTap: onTapCard(context, "Surprised"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void Function() onTapCard(BuildContext context, String label) {
    return () async {
      String? selected = label;

      if (selected != "") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeelingsGame(selectedFeeling: selected),
          ),
        );
      }

    };
  }
}

