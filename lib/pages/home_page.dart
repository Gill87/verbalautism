import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:verbalautism/activities/activity1.dart';
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
                      SubjectWidget(tapFunction: onToActivity, text: 'A B C'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Colors'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Shapes'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Objects'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Food'),
                      SubjectWidget(tapFunction: onToActivity, text: '1 2 3'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Feeling'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Places'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Questions'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Prepositions'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Sight Words'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Actions & Verbs'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Sequence'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Fill Color Game'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Matching Games'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Tracing Games'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Hoot Hoot'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Spelling Practice'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Digital Books'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Car Racing'),
                      SubjectWidget(tapFunction: onToActivity, text: 'Math Practice'),

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
                child: Text('Danny'),
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