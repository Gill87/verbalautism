import 'package:flutter/material.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_lowercase_game.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_mixed_game.dart';
import 'package:verbalautism/activities/abc/games_pages/abc_uppercase_game.dart';
import 'package:verbalautism/components/large_subject_widget.dart';

class Activity1 extends StatelessWidget {
  const Activity1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("ABC")),
      ),

      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LargeSubjectWidget(
              tapFunction: ()=>{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AbcUppercaseGame())
                )
              }, 
              text: "Uppercase", 
              image1: const AssetImage("lib/images/abc_images/CoverAImage.png"),
              width: 300,
              height: 300,
              color: Colors.grey,
            ),
        
            LargeSubjectWidget(
              tapFunction: ()=>{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AbcLowercaseGame())
                )
              }, 
              text: "Lowercase", 
              image1: const AssetImage("lib/images/abc_images/Lowercase_A.png"),
              width: 300,
              height: 300,
              color: Colors.grey,
            ),
        
            LargeSubjectWidget(
              tapFunction: ()=>{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AbcMixedGame())
                )
              }, 
              text: "Mixed", 
              image1: const AssetImage("lib/images/abc_images/MixedLettersImage.png"),
              width: 300,
              height: 300,
              color: Colors.grey,
            ),
        
          ],
        ),
      ),
    );
  }
}