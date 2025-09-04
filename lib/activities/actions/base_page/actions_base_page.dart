import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/actions/games_page/actions_game.dart';
import 'package:verbalautism/components/animations/animated_card.dart';

class ActionsBasePage extends StatefulWidget {
  const ActionsBasePage({super.key});

  @override
  State<ActionsBasePage> createState() => _ActionsBasePageState();
}

class _ActionsBasePageState extends State<ActionsBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        centerTitle: true,
        title: Text(
          "Action Verbs",
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
                  MaterialPageRoute(builder: (context) => const ActionsGame(selectedAction: "")),
                ),
                child: Text("Random Action Verb", style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white)),
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
                      image: "assets/actions_images/climb.svg",
                      label: "Climb",
                      onTap: onTapCard(context, "Climb"),
                    ),
                  
                    _buildCard(
                      context,
                      image: "assets/actions_images/eat.svg",
                      label: "Eat",
                      onTap: onTapCard(context, "Eat"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/actions_images/jump.svg",
                      label: "Jump",
                      onTap: onTapCard(context, "Jump"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/actions_images/kick.svg",
                      label: "Kick",
                      onTap: onTapCard(context, "Kick"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/actions_images/paint.svg",
                      label: "Paint",
                      onTap: onTapCard(context, "Paint"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/actions_images/read.svg",
                      label: "Read",
                      onTap: onTapCard(context, "Read"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/actions_images/run.svg",
                      label: "Run",
                      onTap: onTapCard(context, "Run"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/actions_images/throw.svg",
                      label: "Throw",
                      onTap: onTapCard(context, "Throw"),
                    ),

                    _buildCard(
                      context,
                      image: "assets/actions_images/swim.svg",
                      label: "Swim",
                      onTap: onTapCard(context, "Swim"),
                    ),
                    
                    _buildCard(
                      context,
                      image: "assets/actions_images/sleep.svg",
                      label: "Sleep",
                      onTap: onTapCard(context, "Sleep"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/actions_images/dance.svg",
                      label: "Dance",
                      onTap: onTapCard(context, "Dance"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/actions_images/sing.svg",
                      label: "Sing",
                      onTap: onTapCard(context, "Sing"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/actions_images/dig.svg",
                      label: "Dig",
                      onTap: onTapCard(context, "Dig"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/actions_images/slide.svg",
                      label: "Slide",
                      onTap: onTapCard(context, "Slide"),
                    ),
                    _buildCard(
                      context,
                      image: "assets/actions_images/build.svg",
                      label: "Build",
                      onTap: onTapCard(context, "Build"),
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
            builder: (context) => ActionsGame(selectedAction: selected),
          ),
        );
      }

    };
  }
}