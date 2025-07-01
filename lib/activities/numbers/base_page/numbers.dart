import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/numbers/games_pages/numbers_game.dart';
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
                label: "0-9",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumbersGame(
                    min: 0,
                    max: 9,
                  )),
                ),
              ),
              _buildCard(
                context,
                label: "10-19",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumbersGame(
                    min: 10,
                    max: 19,
                  )),
                ),
              ),
              _buildCard(
                context,
                label: "20-29",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumbersGame(
                    min: 20,
                    max: 29,
                  )),
                ),
              ),

              _buildCard(
                context,
                label: "30-39",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumbersGame(
                    min: 30,
                    max: 39,
                  )),
                ),
              ),
              _buildCard(
                context,
                label: "40-49",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumbersGame(
                    min: 40,
                    max: 49,
                  )),
                ),
              ),
              _buildCard(
                context,
                label: "50-59",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumbersGame(
                    min: 50,
                    max: 59,
                  )),
                ),
              ),
              _buildCard(
                context,
                label: "60-69",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumbersGame(
                    min: 60,
                    max: 69,
                  )),
                ),
              ),
              _buildCard(
                context,
                label: "70-79",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumbersGame(
                    min: 70,
                    max: 79,
                  )),
                ),
              ),
              _buildCard(
                context,
                label: "80-89",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumbersGame(
                    min: 80,
                    max: 89,
                  )),
                ),
              ),

              _buildCard(
                context,
                label: "90-99",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumbersGame(
                    min: 90,
                    max: 99,
                  )),
                ),
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
          width: (MediaQuery.of(context).size.width - 80) / 6,
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
                    color: const Color.fromARGB(255, 33, 150, 243),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
