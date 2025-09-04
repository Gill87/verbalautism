import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/food/games_page/food_game.dart';
import 'package:verbalautism/components/animations/animated_card.dart';

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
    return AnimatedCard(
      onTap: onTap,
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
                    fontSize: 20,
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
        {"name": "Pancakes", "image": "assets/food_images/pancakes.svg"},
        {"name": "Bacon", "image": "assets/food_images/bacon.svg"},
        {"name": "Hash Brown", "image": "assets/food_images/hash_brown.svg"},
        {"name": "Waffles", "image": "assets/food_images/waffles.svg"},
        {"name": "Yogurt", "image": "assets/food_images/yogurt.svg"},
        {"name": "Bagel", "image": "assets/food_images/bagel.svg"},
      ];
    } else if (widget.selectedMeal == "Lunch/Dinner") {
      foods = [
        {"name": "Rice", "image": "assets/food_images/rice.svg"},
        {"name": "Bread", "image": "assets/food_images/bread.svg"},
        {"name": "Pizza", "image": "assets/food_images/pizza.svg"},
        {"name": "Sandwich", "image": "assets/food_images/sandwich.svg"},
        {"name": "Pie", "image": "assets/food_images/pie.svg"},
        {"name": "Chicken Wings", "image": "assets/food_images/chicken_wings.svg"},
        {"name": "Dumplings", "image": "assets/food_images/dumplings.svg"},
        {"name": "Fish and Chips", "image": "assets/food_images/fish_and_chips.svg"},
        {"name": "Hot Dog", "image": "assets/food_images/hot_dog.svg"},
        {"name": "Mac and Cheese", "image": "assets/food_images/mac_and_cheese.svg"},
        {"name": "Ramen", "image": "assets/food_images/ramen.svg"},
        {"name": "Salad", "image": "assets/food_images/salad.svg"},
        {"name": "Sushi", "image": "assets/food_images/sushi.svg"},
        {"name": "Tacos", "image": "assets/food_images/tacos.svg"},
      ];
    } else if (widget.selectedMeal == "Snacks") {
      foods = [
        {"name": "Apple", "image": "assets/food_images/apple.svg"},
        {"name": "Banana", "image": "assets/food_images/banana.svg"},
        {"name": "Strawberry", "image": "assets/food_images/strawberry.svg"},
        {"name": "Orange", "image": "assets/food_images/orange.svg"},
        {"name": "Grapes", "image": "assets/food_images/grapes.svg"},
        {"name": "Chips", "image": "assets/food_images/chips.svg"},
        {"name": "Brownies", "image": "assets/food_images/brownies.svg"},
        {"name": "French Fries", "image": "assets/food_images/french_fries.svg"},
        {"name": "Corn", "image": "assets/food_images/corn.svg"},
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