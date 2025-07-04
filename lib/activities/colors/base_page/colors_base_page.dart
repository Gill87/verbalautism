import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/colors/games_page/colors_game.dart';

class ColorsBasePage extends StatefulWidget {
  const ColorsBasePage({super.key});

  @override
  State<ColorsBasePage> createState() => _ColorsBasePageState();
}

class _ColorsBasePageState extends State<ColorsBasePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "Colors",
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
                label: "Basic Colors",
                onTap: onTapCard(context, "Basic Colors"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.yellow.withOpacity(0.3),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.3,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [          
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple,
                  ],
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: Text(
                  label,
                  style: GoogleFonts.ubuntu(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Needs to be white for ShaderMask
                  ),
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
      String? selected = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select a Color", style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.of(context).pop("Red"),
                  child: Text("Red", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => Navigator.of(context).pop("Green"),
                  child: Text("Green", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  onPressed: () => Navigator.of(context).pop("Yellow"),
                  child: Text("Yellow", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () => Navigator.of(context).pop("Orange"),
                  child: Text("Orange", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => Navigator.of(context).pop("Blue"),
                  child: Text("Blue", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () => Navigator.of(context).pop("Purple"),
                  child: Text("Purple", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  onPressed: () => Navigator.of(context).pop("Brown"),
                  child: Text("Brown", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  onPressed: () => Navigator.of(context).pop("Pink"),
                  child: Text("Pink", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () => Navigator.of(context).pop("White"),
                  child: Text("White", style: GoogleFonts.ubuntu(color: Colors.black, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => Navigator.of(context).pop("Black"),
                  child: Text("Black", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(""),
                  child: Text("Random", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      );

      if (selected != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ColorsGame(selectedColor: selected),
          ),
        );
      }

    };
  }
}