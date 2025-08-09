import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/objects/games_page/object_game.dart';

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
                  MaterialPageRoute(builder: (context) => const ObjectGame(selectedObject: "")),
                ),
                child: Text("Random Object", style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white)),
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
                      label: "Book",
                      image: "assets/objects_images/book.svg",
                      onTap: onTapCard(context, "Book"),
                    ),
                      
                    _buildCard(
                      context,
                      label: "Car",
                      image: "assets/objects_images/car.svg",
                      onTap: onTapCard(context, "Car"),
                    ),
                      
                    _buildCard(
                      context,
                      label: "Clock",
                      image: "assets/objects_images/clock.svg",
                      onTap: onTapCard(context, "Clock"),
                    ),
                      
                    _buildCard(
                      context,
                      label: "Computer",
                      image: "assets/objects_images/computer.svg",
                      onTap: onTapCard(context, "Computer"),
                    ),
                      
                    _buildCard(
                      context,
                      label: "Crayon",
                      image: "assets/objects_images/crayon.svg",
                      onTap: onTapCard(context, "Crayon"),
                    ),
                      
                    _buildCard(
                      context,
                      label: "Pen",
                      image: "assets/objects_images/pen.svg",
                      onTap: onTapCard(context, "Pen"),
                    ),
                      
                    _buildCard(
                      context,
                      label: "Pencil",
                      image: "assets/objects_images/pencil.svg",
                      onTap: onTapCard(context, "Pencil"),
                    ),
                      
                    _buildCard(
                      context,
                      label: "Scissors",
                      image: "assets/objects_images/scissors.svg",
                      onTap: onTapCard(context, "Scissors"),
                    ),
                      
                    _buildCard(
                      context,
                      label: "TV",
                      image: "assets/objects_images/tv.svg",
                      onTap: onTapCard(context, "TV"),
                    ),
                    
                    _buildCard(
                      context,
                      label: "Backpack",
                      image: "assets/objects_images/backpack.svg",
                      onTap: onTapCard(context, "Backpack"),
                    ),

                    _buildCard(
                      context,
                      label: "Chair",
                      image: "assets/objects_images/chair.svg",
                      onTap: onTapCard(context, "Chair"),
                    ),

                    _buildCard(
                      context,
                      label: "Teddy Bear",
                      image: "assets/objects_images/teddy_bear.svg",
                      onTap: onTapCard(context, "Teddy Bear"),
                    ),

                    _buildCard(
                      context,
                      label: "Ruler",
                      image: "assets/objects_images/ruler.svg",
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

                const SizedBox(height: 10),
                           
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


