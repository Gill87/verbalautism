import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
                  MaterialPageRoute(builder: (context) => const FoodGame(selectedFood: "")),
                ),
                child: Text("Random Food", style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white)),
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
                      image: "assets/food_images/apple.svg",
                      label: "Apple",
                      onTap: onTapCard(context, "Apple"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/food_images/banana.svg",
                      label: "Banana",
                      onTap: onTapCard(context, "Banana"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/food_images/cereal.svg",
                      label: "Cereal",
                      onTap: onTapCard(context, "Cereal"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/food_images/egg.svg",
                      label: "Egg",
                      onTap: onTapCard(context, "Egg"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/food_images/milk.svg",
                      label: "Milk",
                      onTap: onTapCard(context, "Milk"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/food_images/orange.svg",
                      label: "Orange",
                      onTap: onTapCard(context, "Orange"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/food_images/rice.svg",
                      label: "Rice",
                      onTap: onTapCard(context, "Rice"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/food_images/strawberry.svg",
                      label: "Strawberry",
                      onTap: onTapCard(context, "Strawberry"),
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
            builder: (context) => FoodGame(selectedFood: selected),
          ),
        );
      }

    };
  }
}

