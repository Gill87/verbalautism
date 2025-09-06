import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/food/base_page/food_selection_page.dart';
import 'package:verbalautism/components/image_activity_card.dart';

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
          alignment: Alignment.center,
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
              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    ImageActivityCard(
                      image: "assets/food_images/cereal.svg",
                      label: "Breakfast",
                      onTap: onTapCard(context, "Breakfast"),
                    ),

                    ImageActivityCard(
                      image: "assets/food_images/rice.svg",
                      label: "Lunch/Dinner",
                      onTap: onTapCard(context, "Lunch/Dinner"),
                    ),

                    ImageActivityCard(
                      image: "assets/food_images/apple.svg",
                      label: "Snacks",
                      onTap: onTapCard(context, "Snacks"),
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
            builder: (context) => FoodSelectionPage(selectedMeal: selected),
          ),
        );
      }
    };
  }
}