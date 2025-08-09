import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/food/games_page/food_game.dart';

class FoodSelectionPage extends StatefulWidget {
  const FoodSelectionPage({
    super.key,
    required this.selectedMeal,
  });

  final String selectedMeal;

  @override
  State<FoodSelectionPage> createState() => _FoodSelectionPageState();
}

class _FoodSelectionPageState extends State<FoodSelectionPage> {

  List<Map<String, String>> foods = [];

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

  @override
  void initState() {
    super.initState();
    if (widget.selectedMeal == "Breakfast") {
      foods = [
        {"name": "Cereal", "image": "assets/food_images/cereal.svg"},
        {"name": "Milk", "image": "assets/food_images/milk.svg"},
        {"name": "Egg", "image": "assets/food_images/egg.svg"},
      ];
    } else if (widget.selectedMeal == "Lunch/Dinner") {
      foods = [
        {"name": "Rice", "image": "assets/food_images/rice.svg"},
        {"name": "Bread", "image": "assets/food_images/bread.svg"},
      ];
    } else if (widget.selectedMeal == "Snacks") {
      foods = [
        {"name": "Apple", "image": "assets/food_images/apple.svg"},
        {"name": "Banana", "image": "assets/food_images/banana.svg"},
        {"name": "Strawberry", "image": "assets/food_images/strawberry.svg"},
        {"name": "Orange", "image": "assets/food_images/orange.svg"},
      ];
    } else {
      foods = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "${widget.selectedMeal} Foods",
          style: GoogleFonts.ubuntu(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_images/32442923_7895078.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
            minWidth: MediaQuery.of(context).size.width,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: foods.map((food) {
                    return _buildCard(
                      context,
                      label: food['name']!,
                      image: food['image']!,
                      onTap: () {
                        // Navigate to the game page for the selected food
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodGame(selectedFood: food['name']!),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}