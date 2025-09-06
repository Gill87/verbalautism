import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/numbers/base_page/numbers_selection_page.dart';
import 'package:verbalautism/components/animations/animated_card.dart';

class Numbers extends StatelessWidget {
  const Numbers({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "Numbers",
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
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildCard(
                  context,
                  label: "0 - 9",
                  onTap: onTapCard(context, "0-9", 0, 9),
                ),
                _buildCard(
                  context,
                  label: "10 - 19",
                  onTap: onTapCard(context, "10-19", 10, 19),
                ),
                _buildCard(
                  context,
                  label: "20 - 29",
                  onTap: onTapCard(context, "20-29", 20, 29),
                ),
        
                _buildCard(
                  context,
                  label: "30 - 39",
                  onTap: onTapCard(context, "30-39", 30, 39),
                ),
                
                _buildCard(
                  context,
                  label: "40 - 49",
                  onTap: onTapCard(context, "40-49", 40, 49),
                ),
        
                _buildCard(
                  context,
                  label: "50 - 59",
                  onTap: onTapCard(context, "50-59", 50, 59),
                ),
        
                _buildCard(
                  context,
                  label: "60 - 69",
                  onTap: onTapCard(context, "60-69", 60, 69),
                ),
        
                _buildCard(
                  context,
                  label: "70 - 79",
                  onTap: onTapCard(context, "70-79", 70, 79),
                ),
        
                _buildCard(
                  context,
                  label: "80 - 89",
                  onTap: onTapCard(context, "80-89", 80, 89),
                ),
        
                _buildCard(
                  context,
                  label: "90 - 99",
                  onTap: onTapCard(context, "90-99", 90, 99),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String label, required VoidCallback onTap}) {
    return AnimatedCard(
      onTap: onTap,
      child: Card(
        elevation: 10,
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 150,
          height: 150,
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
}

// Updated onTapCard function
void Function() onTapCard(BuildContext context, String label, int min, int max) {
  return () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NumberSelectionPage(
          rangeLabel: label,
          min: min,
          max: max,
        ),
      ),
    );
  };
}

