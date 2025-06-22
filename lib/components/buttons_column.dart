import 'package:flutter/material.dart';
import 'package:verbalautism/components/circular_button.dart';

class ButtonsColumn extends StatelessWidget {
  const ButtonsColumn({super.key});

  // Is Desktop
  bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 1000;
    
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: isDesktop(context) 
          ? EdgeInsets.only(right: MediaQuery.sizeOf(context).height * 0.05)
          : EdgeInsets.only(right: MediaQuery.sizeOf(context).height * 0.02),
        child: const SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              CircularButton(text: "Hi", image: AssetImage("assets/letter_colors/glitter_6.jpg"), audioAsset: "audio_files/hi.mp3",),
              SizedBox(height: 10,),
              CircularButton(text: "Please", image: AssetImage("assets/letter_colors/glitter_2.jpg"), audioAsset: "audio_files/please.mp3"),
              SizedBox(height: 10,),
              CircularButton(text: "Thanks", image: AssetImage("assets/letter_colors/glitter_3.jpg"), audioAsset: "audio_files/thanks.mp3"),
              SizedBox(height: 10,),
              CircularButton(text: "Sorry", image: AssetImage("assets/letter_colors/glitter_4.jpg"),audioAsset: "audio_files/sorry.mp3"),
              SizedBox(height: 10,),
              CircularButton(text: "Bye", image: AssetImage("assets/letter_colors/glitter_5.jpg"), audioAsset: "audio_files/bye.mp3"),
              SizedBox(height: 10,),
              CircularButton(text: "Stop", image: AssetImage("assets/letter_colors/glitter_1.jpg"), audioAsset: "audio_files/stop.mp3"),
            ],
          )
        )
      )
    );
  }
}