import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_lowercase_game.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_mixed_game.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_uppercase_game.dart';

class Activity1 extends StatelessWidget {
  const Activity1({super.key});

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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_images/32442923_7895078.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _buildCard(
                context,
                label: "Uppercase",
                image: "assets/abc_images/Uppercase_A.svg",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AbcUppercaseGame()),
                ),
              ),
              _buildCard(
                context,
                label: "Lowercase",
                image: "assets/abc_images/Lowercase_A.svg",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AbcLowercaseGame()),
                ),
              ),
              _buildCard(
                context,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                Transform.scale(
                  scale: 1.5,
                  child: SvgPicture.asset(
                    image,
                    width: 100,
                    height: 100,
                  ),
                ),              
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
}
