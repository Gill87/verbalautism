import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/objects/games_page/object_game.dart';
import 'package:verbalautism/components/image_activity_card.dart';

class ObjectsBasePage extends StatefulWidget {
  const ObjectsBasePage({super.key});

  @override
  State<ObjectsBasePage> createState() => _ObjectsBasePageState();
}

class _ObjectsBasePageState extends State<ObjectsBasePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "Objects",
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
                      MaterialPageRoute(builder: (context) => const ObjectGame(selectedObject: "")),
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
                      MaterialPageRoute(builder: (context) => const ObjectGame(selectedObject: "Shuffle")),
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
                      label: "Book",
                      image: "assets/objects_images/book.webp",
                      onTap: onTapCard(context, "Book"),
                    ),
                      
                    ImageActivityCard(
                      label: "Car",
                      image: "assets/objects_images/car.webp",
                      onTap: onTapCard(context, "Car"),
                    ),
                      
                    ImageActivityCard(
                      label: "Clock",
                      image: "assets/objects_images/clock.webp",
                      onTap: onTapCard(context, "Clock"),
                    ),
                      
                    ImageActivityCard(
                      label: "Computer",
                      image: "assets/objects_images/computer.webp",
                      onTap: onTapCard(context, "Computer"),
                    ),
                      
                    ImageActivityCard(
                      label: "Crayon",
                      image: "assets/objects_images/crayon.webp",
                      onTap: onTapCard(context, "Crayon"),
                    ),
                      
                    ImageActivityCard(
                      label: "Pen",
                      image: "assets/objects_images/pen.webp",
                      onTap: onTapCard(context, "Pen"),
                    ),
                      
                    ImageActivityCard(
                      label: "Pencil",
                      image: "assets/objects_images/pencil.webp",
                      onTap: onTapCard(context, "Pencil"),
                    ),
                      
                    ImageActivityCard(
                      label: "Scissors",
                      image: "assets/objects_images/scissors.webp",
                      onTap: onTapCard(context, "Scissors"),
                    ),
                      
                    ImageActivityCard(
                      label: "TV",
                      image: "assets/objects_images/tv.webp",
                      onTap: onTapCard(context, "TV"),
                    ),
                    
                    ImageActivityCard(
                      label: "Backpack",
                      image: "assets/objects_images/backpack.webp",
                      onTap: onTapCard(context, "Backpack"),
                    ),

                    ImageActivityCard(
                      label: "Chair",
                      image: "assets/objects_images/chair.webp",
                      onTap: onTapCard(context, "Chair"),
                    ),

                    ImageActivityCard(
                      label: "Teddy Bear",
                      image: "assets/objects_images/teddy_bear.webp",
                      onTap: onTapCard(context, "Teddy Bear"),
                    ),

                    ImageActivityCard(
                      label: "Ruler",
                      image: "assets/objects_images/ruler.webp",
                      onTap: onTapCard(context, "Ruler"),
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
}

void Function() onTapCard(BuildContext context, String label) {
  return () async {
    String? selected = label;

    if (selected != "") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObjectGame(selectedObject: selected),
        ),
      );
    }

  };
}