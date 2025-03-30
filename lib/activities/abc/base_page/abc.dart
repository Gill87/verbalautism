import 'package:flutter/material.dart';
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

      body: Row(
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
            image1: const AssetImage("lib/images/abc_images/uppercaseA.png")
          ),

          LargeSubjectWidget(
            tapFunction: ()=>{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AbcUppercaseGame())
              )
            }, 
            text: "Lowercase", image1: 
            const AssetImage("lib/images/abc_images/lowercaseA.png")
          ),

          LargeSubjectWidget(
            tapFunction: ()=>{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AbcUppercaseGame())
              )
            }, 
            text: "Mixed", 
            image1: const AssetImage("lib/images/abc_images/bothA.png")
          ),

        ],
      ),
    );
  }
}