import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:verbalautism/activities/activity1.dart';
import 'package:verbalautism/components/sound_button.dart';
import 'package:verbalautism/components/subject_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // Sign out method
  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {

  void onToActivity(){
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => Activity1()
      )
    );
  }
    return Scaffold(

      // Start Katherine
      appBar: AppBar(
        title: Text("Katherine"),
        toolbarHeight: 80,
        actions: [
          IconButton(
            onPressed: signUserOut, 
            icon: Icon(Icons.logout)
          )
        ],
      ),
      // End Katherine
      
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                    
              // Start Guri
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Container(
                  child: GridView.count(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                    children: [
                      SubjectWidget(tapFunction: onToActivity, text: 'A B C', image1: AssetImage('lib/images/abc.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Colors', image1: AssetImage('lib/images/colors.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Shapes', image1: AssetImage('lib/images/shapes.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Objects', image1: AssetImage('lib/images/geography.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Food', image1: AssetImage('lib/images/food.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: '1 2 3', image1: AssetImage('lib/images/123.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Feeling', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Places',  image1: AssetImage('lib/images/places.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Questions', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Prepositions', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Sight Words', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Actions & Verbs', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Sequence', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Fill Color Game', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Matching Games', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Tracing Games', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Hoot Hoot', image1: AssetImage('lib/images/birds.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Spelling Practice', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Digital Books', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Car Racing', image1: AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Math Practice', image1: AssetImage('lib/images/drake.jpg')),

                    ],
                  ),
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(97, 161, 140, 140),
                  ),
                  
                ),
              ),       
              // End Guri
                    
              // Start Danny    
              Container(
                child: Row(
                  children: [
                    SoundButton(tapFunction: ()=> (), text: 'Help', desiredColor: Colors.orange),
                    const SizedBox(width: 20),
                    SoundButton(tapFunction: ()=> (), text: 'Yes', desiredColor: Colors.green),
                    const SizedBox(width:20),
                    SoundButton(tapFunction: ()=> (), text: 'No', desiredColor: Colors.red),
                  ],
                ),
              ),       
              // End Danny
            ],
          ),

        // Start Rohan
          Container(
            padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).height * 0.15),
            child: Text("Rohan"),
          )

        // End Rohan
        ],
      ),

    );
  }
}