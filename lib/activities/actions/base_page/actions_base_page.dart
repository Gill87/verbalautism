import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/activities/actions/games_page/actions_game.dart';
import 'package:verbalautism/components/image_activity_card.dart';

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
              image: AssetImage("assets/background_images/colorful_bg.webp"),
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

                    ImageActivityCard(
                      image: "assets/actions_images/climb.svg",
                      label: "Climb",
                      onTap: onTapCard(context, "Climb"),
                    ),
                  
                    ImageActivityCard(
                      image: "assets/actions_images/eat.svg",
                      label: "Eat",
                      onTap: onTapCard(context, "Eat"),
                    ),

                    ImageActivityCard(
                      image: "assets/actions_images/jump.svg",
                      label: "Jump",
                      onTap: onTapCard(context, "Jump"),
                    ),

                    ImageActivityCard(
                      image: "assets/actions_images/kick.svg",
                      label: "Kick",
                      onTap: onTapCard(context, "Kick"),
                    ),
                    ImageActivityCard(
                      image: "assets/actions_images/paint.svg",
                      label: "Paint",
                      onTap: onTapCard(context, "Paint"),
                    ),
                    ImageActivityCard(
                      image: "assets/actions_images/read.svg",
                      label: "Read",
                      onTap: onTapCard(context, "Read"),
                    ),

                    ImageActivityCard(
                      image: "assets/actions_images/run.svg",
                      label: "Run",
                      onTap: onTapCard(context, "Run"),
                    ),

                    ImageActivityCard(
                      image: "assets/actions_images/throw.svg",
                      label: "Throw",
                      onTap: onTapCard(context, "Throw"),
                    ),

                    ImageActivityCard(
                      image: "assets/actions_images/swim.svg",
                      label: "Swim",
                      onTap: onTapCard(context, "Swim"),
                    ),
                    
                    ImageActivityCard(
                      image: "assets/actions_images/sleep.svg",
                      label: "Sleep",
                      onTap: onTapCard(context, "Sleep"),
                    ),
                    ImageActivityCard(
                      image: "assets/actions_images/dance.svg",
                      label: "Dance",
                      onTap: onTapCard(context, "Dance"),
                    ),
                    ImageActivityCard(
                      image: "assets/actions_images/sing.svg",
                      label: "Sing",
                      onTap: onTapCard(context, "Sing"),
                    ),
                    ImageActivityCard(
                      image: "assets/actions_images/dig.svg",
                      label: "Dig",
                      onTap: onTapCard(context, "Dig"),
                    ),
                    ImageActivityCard(
                      image: "assets/actions_images/slide.svg",
                      label: "Slide",
                      onTap: onTapCard(context, "Slide"),
                    ),
                    ImageActivityCard(
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