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
              CircularButton(text: "Hi", color:  Color.fromARGB(255, 33, 150, 243),),
              SizedBox(height: 10,),
              CircularButton(text: "Please", color: Color.fromARGB(255, 33, 150, 243),),
              SizedBox(height: 10,),
              CircularButton(text: "Thanks", color: Color.fromARGB(255, 33, 150, 243),),
              SizedBox(height: 10,),
              CircularButton(text: "Sorry", color: Color.fromARGB(255, 33, 150, 243),),
              SizedBox(height: 10,),
              CircularButton(text: "Bye", color: Color.fromARGB(255, 33, 150, 243),),
              SizedBox(height: 10,),
              CircularButton(text: "Stop", color: Color.fromARGB(255, 33, 150, 243),),
            ],
          )
        )
      )
    );
  }
}