import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/shapes/games_page/shapes_game.dart';

class ShapesBasePage extends StatefulWidget {
  const ShapesBasePage({super.key});

  @override
  State<ShapesBasePage> createState() => _ShapesBasePageState();
}

class _ShapesBasePageState extends State<ShapesBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "Shapes",
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
                label: "Shapes",
                onTap: onTapCard(context, "Shapes"),
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
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.3,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [          
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
      String? selected = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select a Shape", style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Circle"),
                  child: Text("Circle", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Triangle"),
                  child: Text("Triangle", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Square"),
                  child: Text("Square", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Rectangle"),
                  child: Text("Rectangle", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Star"),
                  child: Text("Star", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Heart"),
                  child: Text("Heart", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
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
            builder: (context) => ShapesGame(selectedShape: selected),
          ),
        );
      }

    };
  }
}

