import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/places/games_page/places_game.dart';

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

                    _buildCard(
                      context,
                      image: "assets/places_images/school.svg",
                      label: "School",
                      onTap: onTapCard(context, "School"),
                    ),
                  
                    _buildCard(
                      context,
                      image: "assets/places_images/grocery_store.svg",
                      label: "Grocery Store",
                      onTap: onTapCard(context, "Grocery Store"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/places_images/library.svg",
                      label: "Library",
                      onTap: onTapCard(context, "Library"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/places_images/hospital.svg",
                      label: "Hospital",
                      onTap: onTapCard(context, "Hospital"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/places_images/mall.svg",
                      label: "Mall",
                      onTap: onTapCard(context, "Mall"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/places_images/post_office.svg",
                      label: "Post Office",
                      onTap: onTapCard(context, "Post Office"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/places_images/police_station.svg",
                      label: "Police Station",
                      onTap: onTapCard(context, "Police Station"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/places_images/fire_station.svg",
                      label: "Fire Station",
                      onTap: onTapCard(context, "Fire Station"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/places_images/airport.svg",
                      label: "Airport",
                      onTap: onTapCard(context, "Airport"),
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

