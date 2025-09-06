import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/shapes/games_page/shapes_game.dart';
import 'package:verbalautism/components/image_activity_card.dart';

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
                  MaterialPageRoute(builder: (context) => const ShapesGame(selectedShape: "")),
                ),
                child: Text("Random Shape", style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white)),
              ),

              const SizedBox(height: 50,),
              
              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    ImageActivityCard(
                      image: "assets/shapes_images/circle.svg",
                      label: "Circle",
                      onTap: onTapCard(context, "Circle"),
                    ),
                    
                    ImageActivityCard(
                      image: "assets/shapes_images/triangle.svg",
                      label: "Triangle",
                      onTap: onTapCard(context, "Triangle"),
                    ),

                    ImageActivityCard(
                      image: "assets/shapes_images/rectangle.svg",
                      label: "Rectangle",
                      onTap: onTapCard(context, "Rectangle"),
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
            builder: (context) => ShapesGame(selectedShape: selected),
          ),
        );
      }

    };
  }
}

