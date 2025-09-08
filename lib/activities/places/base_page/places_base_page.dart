import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/places/games_page/places_game.dart';
import 'package:verbalautism/components/image_activity_card.dart';

class PlacesBasePage extends StatefulWidget {
  const PlacesBasePage({super.key});

  @override
  State<PlacesBasePage> createState() => _PlacesBasePageState();
}

class _PlacesBasePageState extends State<PlacesBasePage> {
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlacesGame(selectedPlace: "")),
                ),
                child: Text("Random Place", style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white)),
              ),

              const SizedBox(height: 20,),

              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [

                    ImageActivityCard(
                      image: "assets/places_images/school.webp",
                      label: "School",
                      onTap: onTapCard(context, "School"),
                    ),
                  
                    ImageActivityCard(
                      image: "assets/places_images/grocery_store.webp",
                      label: "Grocery Store",
                      onTap: onTapCard(context, "Grocery Store"),
                    ),

                    ImageActivityCard(
                      image: "assets/places_images/library.webp",
                      label: "Library",
                      onTap: onTapCard(context, "Library"),
                    ),

                    ImageActivityCard(
                      image: "assets/places_images/hospital.webp",
                      label: "Hospital",
                      onTap: onTapCard(context, "Hospital"),
                    ),
                    ImageActivityCard(
                      image: "assets/places_images/mall.webp",
                      label: "Mall",
                      onTap: onTapCard(context, "Mall"),
                    ),
                    ImageActivityCard(
                      image: "assets/places_images/post_office.webp",
                      label: "Post Office",
                      onTap: onTapCard(context, "Post Office"),
                    ),

                    ImageActivityCard(
                      image: "assets/places_images/police_station.webp",
                      label: "Police Station",
                      onTap: onTapCard(context, "Police Station"),
                    ),

                    ImageActivityCard(
                      image: "assets/places_images/fire_station.webp",
                      label: "Fire Station",
                      onTap: onTapCard(context, "Fire Station"),
                    ),

                    ImageActivityCard(
                      image: "assets/places_images/airport.webp",
                      label: "Airport",
                      onTap: onTapCard(context, "Airport"),
                    ),

                    ImageActivityCard(
                      image: "assets/places_images/barn.webp",
                      label: "Barn",
                      onTap: onTapCard(context, "Barn"),
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
            builder: (context) => PlacesGame(selectedPlace: selected),
          ),
        );
      }

    };
  }
}

