import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/sight_word/games_page/sight_game.dart';

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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.yellow.withOpacity(0.3),
      child: Card(
        elevation: 10,
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 200,
          height: 230,
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

