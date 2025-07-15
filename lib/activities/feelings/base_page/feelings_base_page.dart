import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/feelings/games_page/feelings_game.dart';

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
                  MaterialPageRoute(builder: (context) => const FeelingsGame(selectedFeeling: "")),
                ),
                child: Text("Random Feeling", style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildCard(
                      context,
                      image: "assets/feelings_images/happy.svg",
                      label: "Happy",
                      onTap: onTapCard(context, "Happy"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/feelings_images/sad.svg",
                      label: "Sad",
                      onTap: onTapCard(context, "Sad"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/feelings_images/angry.svg",
                      label: "Angry",
                      onTap: onTapCard(context, "Angry"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/feelings_images/curious.svg",
                      label: "Curious",
                      onTap: onTapCard(context, "Curious"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/feelings_images/sick.svg",
                      label: "Sick",
                      onTap: onTapCard(context, "Sick"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/feelings_images/surprised.svg",
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
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Transform.scale(
                  scale: 1.5,
                  child: SvgPicture.asset(
                    image,
                    width: 100,
                    height: 100,
                  ),
                ),   
                
                const SizedBox(height: 30),
           
                Text(
                  label,
                  style: GoogleFonts.ubuntu(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                ),
              )
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

