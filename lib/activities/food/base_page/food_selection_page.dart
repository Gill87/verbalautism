import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/food/games_page/food_game.dart';
import 'package:verbalautism/components/image_activity_card.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.selectedMeal == "Breakfast") {
      foods = [
        {"name": "Cereal", "image": "assets/food_images/cereal.webp"},
        {"name": "Milk", "image": "assets/food_images/milk.webp"},
        {"name": "Egg", "image": "assets/food_images/egg.webp"},
        {"name": "Pancakes", "image": "assets/food_images/pancakes.webp"},
        {"name": "Bacon", "image": "assets/food_images/bacon.webp"},
        {"name": "Hash Brown", "image": "assets/food_images/hash_brown.webp"},
        {"name": "Waffles", "image": "assets/food_images/waffles.webp"},
        {"name": "Yogurt", "image": "assets/food_images/yogurt.webp"},
        {"name": "Bagel", "image": "assets/food_images/bagel.webp"},
      ];
    } else if (widget.selectedMeal == "Lunch/Dinner") {
      foods = [
        {"name": "Rice", "image": "assets/food_images/rice.webp"},
        {"name": "Bread", "image": "assets/food_images/bread.webp"},
        {"name": "Pizza", "image": "assets/food_images/pizza.webp"},
        {"name": "Sandwich", "image": "assets/food_images/sandwich.webp"},
        {"name": "Pie", "image": "assets/food_images/pie.webp"},
        {"name": "Chicken Wings", "image": "assets/food_images/chicken_wings.webp"},
        {"name": "Dumplings", "image": "assets/food_images/dumplings.webp"},
        {"name": "Fish and Chips", "image": "assets/food_images/fish_and_chips.webp"},
        {"name": "Hot Dog", "image": "assets/food_images/hot_dog.webp"},
        {"name": "Mac and Cheese", "image": "assets/food_images/mac_and_cheese.webp"},
        {"name": "Ramen", "image": "assets/food_images/ramen.webp"},
        {"name": "Salad", "image": "assets/food_images/salad.webp"},
        {"name": "Sushi", "image": "assets/food_images/sushi.webp"},
        {"name": "Tacos", "image": "assets/food_images/tacos.webp"},
      ];
    } else if (widget.selectedMeal == "Snacks") {
      foods = [
        {"name": "Apple", "image": "assets/food_images/apple.webp"},
        {"name": "Banana", "image": "assets/food_images/banana.webp"},
        {"name": "Strawberry", "image": "assets/food_images/strawberry.webp"},
        {"name": "Orange", "image": "assets/food_images/orange.webp"},
        {"name": "Grapes", "image": "assets/food_images/grapes.webp"},
        {"name": "Chips", "image": "assets/food_images/chips.webp"},
        {"name": "Brownies", "image": "assets/food_images/brownies.webp"},
        {"name": "French Fries", "image": "assets/food_images/french_fries.webp"},
        {"name": "Corn", "image": "assets/food_images/corn.webp"},
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
              image: AssetImage("assets/background_images/colorful_bg.webp"),
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
                    return ImageActivityCard(
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