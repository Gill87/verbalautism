import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/colors/games_page/colors_game.dart';
import 'package:verbalautism/components/animations/animated_card.dart';

class ColorsBasePage extends StatefulWidget {
  const ColorsBasePage({super.key});

  @override
  State<ColorsBasePage> createState() => _ColorsBasePageState();
}

class _ColorsBasePageState extends State<ColorsBasePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "Colors",
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
                      MaterialPageRoute(builder: (context) => const ColorsGame(selectedColor: "")),
                    ),
                    child: Text("Random Color", style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white)),
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
                          label: "Red",
                          mainColor: Colors.red,
                          onTap: onTapCard(context, "Red"),
                        ),
                        _buildCard(
                          context,
                          label: "Blue",
                          mainColor: Colors.blue,
                          onTap: onTapCard(context, "Blue"),
                        ),
                            
                        _buildCard(
                          context,
                          label: "Purple",
                          mainColor: Colors.purple,
                          onTap: onTapCard(context, "Purple"),
                        ),
                            
                        _buildCard(
                          context,
                          label: "Green",
                          mainColor: Colors.green,
                          onTap: onTapCard(context, "Green"),
                        ),
                            
                        _buildCard(
                          context,
                          label: "Yellow",
                          mainColor: Colors.yellow,
                          onTap: onTapCard(context, "Yellow"),
                        ),
                            
                        _buildCard(
                          context,
                          label: "White",
                          mainColor: Colors.white,
                          onTap: onTapCard(context, "White"),
                        ),
                            
                        _buildCard(
                          context,
                          label: "Orange",
                          mainColor: Colors.orange,
                          onTap: onTapCard(context, "Orange"),
                        ),
                            
                        _buildCard(
                          context,
                          label: "Pink",
                          mainColor: Colors.pink,
                          onTap: onTapCard(context, "Pink"),
                        ),
                            
                        _buildCard(
                          context,
                          label: "Brown",
                          mainColor: Colors.brown,
                          onTap: onTapCard(context, "Brown"),
                        ),
                            
                        _buildCard(
                          context,
                          label: "Black",
                          mainColor: Colors.black,
                          onTap: onTapCard(context, "Black"),
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
      {required String label, required VoidCallback onTap, required Color mainColor}) {
    return AnimatedCard(
      onTap: onTap,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: mainColor,
        child: Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [          
              Text(
                label,
                style: GoogleFonts.ubuntu(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: (label == "White" || label == "Yellow") ? Colors.black : Colors.white,
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
            builder: (context) => ColorsGame(selectedColor: selected),
          ),
        );
      }

    };
  }
}