import 'package:flutter/material.dart';
import 'package:verbalautism/components/home%20page%20components/circular_button.dart';

class ButtonsColumn extends StatelessWidget {
  const ButtonsColumn({super.key});

  // Is Desktop
  bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width <= 1000;
      
  bool isSmallHeight(BuildContext context) =>
    MediaQuery.of(context).size.height <= 650;

  // Calculate responsive spacing between buttons
  double _getButtonSpacing(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    if (screenHeight <= 500) {
      return 8; // Tight spacing for very small screens
    } else if (screenHeight <= 600) {
      return 12;
    } else if (screenHeight <= 700) {
      return 16;
    } else {
      return 20; // Default spacing
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonSpacing = _getButtonSpacing(context);
    
    return SafeArea(
      child: Container(
        padding: isDesktop(context)
           ? EdgeInsets.only(right: MediaQuery.sizeOf(context).height * 0.02)
          : EdgeInsets.only(right: MediaQuery.sizeOf(context).height * 0.05),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: buttonSpacing), // Top padding
              const CircularButton(
                text: "Hi", 
                image: AssetImage("assets/sound_colors/gold_glitter.jpg"), 
                audioAsset: "audio_files/hi.mp3",
              ),
              SizedBox(height: buttonSpacing),
              const CircularButton(
                text: "Please", 
                image: AssetImage("assets/sound_colors/pink_glitter.jpg"), 
                audioAsset: "audio_files/please.mp3"
              ),
              SizedBox(height: buttonSpacing),
              const CircularButton(
                text: "Thanks", 
                image: AssetImage("assets/sound_colors/purple_glitter.jpg"), 
                audioAsset: "audio_files/thanks.mp3"
              ),
              SizedBox(height: buttonSpacing),
              const CircularButton(
                text: "Sorry", 
                image: AssetImage("assets/sound_colors/blue_glitter.jpg"), 
                audioAsset: "audio_files/sorry.mp3"
              ),
              SizedBox(height: buttonSpacing),
              const CircularButton(
                text: "Bye", 
                image: AssetImage("assets/sound_colors/yellow_glitter.jpg"), 
                audioAsset: "audio_files/bye.mp3"
              ),
              SizedBox(height: buttonSpacing),
              const CircularButton(
                text: "Stop", 
                image: AssetImage("assets/sound_colors/red_glitter.jpg"), 
                audioAsset: "audio_files/stop.mp3"
              ),
              SizedBox(height: buttonSpacing), // Bottom padding
            ],
          )
        )
      )
    );
  }
}