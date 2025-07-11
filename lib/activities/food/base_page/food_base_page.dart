import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/food/games_page/food_game.dart';

class FoodBasePage extends StatefulWidget {
  const FoodBasePage({super.key});

  @override
  State<FoodBasePage> createState() => _FoodBasePageState();
}

class _FoodBasePageState extends State<FoodBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "Food",
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
                label: "Common Foods",
                onTap: onTapCard(context, "Common Foods"),
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
            title: Text("Select a Food", style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Apple"),
                  child: Text("Apple", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Banana"),
                  child: Text("Banana", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Bread"),
                  child: Text("Bread", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Cereal"),
                  child: Text("Cereal", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Egg"),
                  child: Text("Egg", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Milk"),
                  child: Text("Milk", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Orange"),
                  child: Text("Orange", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Rice"),
                  child: Text("Rice", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 33, 150, 243)),
                  onPressed: () => Navigator.of(context).pop("Strawberry"),
                  child: Text("Strawberry", style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
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
            builder: (context) => FoodGame(selectedFood: selected),
          ),
        );
      }

    };
  }
}

