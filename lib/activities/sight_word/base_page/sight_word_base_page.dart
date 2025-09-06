import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/sight_word/games_page/sight_game.dart';
import 'package:verbalautism/components/animations/animated_card.dart';

class SightWordBasePage extends StatefulWidget {
  const SightWordBasePage({super.key});

  @override
  State<SightWordBasePage> createState() => _SightWordBasePageState();
}

class _SightWordBasePageState extends State<SightWordBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "Places",
          style: GoogleFonts.ubuntu(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SightWordGame(selectedSightWord: "")),
                ),
                child: Text("Random Sight Word", style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white)),
              ),

              const SizedBox(height: 20,),

              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [

                    _buildCard(
                      context,
                      image: "assets/sight_word_images/and.svg",
                      label: "And",
                      onTap: onTapCard(context, "And"),
                    ),
                  
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/can.svg",
                      label: "Can",
                      onTap: onTapCard(context, "Can"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/sight_word_images/for.svg",
                      label: "For",
                      onTap: onTapCard(context, "For"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/sight_word_images/is.svg",
                      label: "Is",
                      onTap: onTapCard(context, "Is"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/it.svg",
                      label: "It",
                      onTap: onTapCard(context, "It"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/me.svg",
                      label: "Me",
                      onTap: onTapCard(context, "Me"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/sight_word_images/see.svg",
                      label: "See",
                      onTap: onTapCard(context, "See"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/sight_word_images/we.svg",
                      label: "We",
                      onTap: onTapCard(context, "We"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/you.svg",
                      label: "You",
                      onTap: onTapCard(context, "You"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/by.svg",
                      label: "By",
                      onTap: onTapCard(context, "By"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/do.svg",
                      label: "Do",
                      onTap: onTapCard(context, "Do"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/give.svg",
                      label: "Give",
                      onTap: onTapCard(context, "Give"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/from.svg",
                      label: "From",
                      onTap: onTapCard(context, "From"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/go.svg",
                      label: "Go",
                      onTap: onTapCard(context, "Go"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/of.svg",
                      label: "Of",
                      onTap: onTapCard(context, "Of"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/on.svg",
                      label: "On",
                      onTap: onTapCard(context, "On"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/that.svg",
                      label: "That",
                      onTap: onTapCard(context, "That"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/this.svg",
                      label: "This",
                      onTap: onTapCard(context, "This"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/with.svg",
                      label: "With",
                      onTap: onTapCard(context, "With"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/or.svg",
                      label: "Or",
                      onTap: onTapCard(context, "Or"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/will.svg",
                      label: "Will",
                      onTap: onTapCard(context, "Will"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/help.svg",
                      label: "Help",
                      onTap: onTapCard(context, "Help"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/sight_word_images/tell.svg",
                      label: "Tell",
                      onTap: onTapCard(context, "Tell"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/made.svg",
                      label: "Made",
                      onTap: onTapCard(context, "Made"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/sight_word_images/use.svg",
                      label: "Use",
                      onTap: onTapCard(context, "Use"),
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

  Widget _buildCard(BuildContext context,
      {required String label, required String image, required VoidCallback onTap}) {
    return AnimatedCard(
      onTap: onTap,
      child: Card(
        elevation: 10,
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.fredoka(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
            builder: (context) => SightWordGame(selectedSightWord: selected),
          ),
        );
      }

    };
  }
}

