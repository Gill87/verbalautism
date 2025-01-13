import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbalautism/activities/activity1.dart';
import 'package:verbalautism/components/schedule_button.dart';
import 'package:verbalautism/components/sound_button.dart';
import 'package:verbalautism/components/subject_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/features/auth/presentation/cubits/auth_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final String menuUser = '';

  // Sign out method
  void signUserOut(){
    final authCubit = context.read<AuthCubit>();
    authCubit.logout();
  }

  @override
  Widget build(BuildContext context) {

  void onToActivity(){
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const Activity1()
      )
    );
  }


  // Time
  var time = DateTime.now();

    return Scaffold(

      // Start Katherine
      appBar: AppBar(

        // title: Text(
        //   "Academic Support",
        //   style: GoogleFonts.ubuntu(fontSize: 30, color: Colors.black, letterSpacing: 1),
        // ),

        title: const Image(image: AssetImage('lib/images/appbarlogo.png'), height: 100,),

        toolbarHeight: 80,

        actions: [

          const Image(image: AssetImage('lib/images/cash.png')),
          Text(
            '= \$200',  // Money Feature Needed
            style: GoogleFonts.ubuntu(color: Colors.green[500], fontSize: 18),
            ),

          const SizedBox(width: 40,),
          
          ScheduleButton(tapFunction: () => ()),

          const SizedBox(width: 30),     


          IconButton(
            icon: const Icon(Icons.music_note),
            onPressed: () => (),
          ),
          
          const SizedBox(width: 30),     

          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => (),
          ),

          const SizedBox(width: 30),

          const DropdownMenu(
            dropdownMenuEntries: <DropdownMenuEntry<String>>[
              DropdownMenuEntry(value: '', label: 'Danny'),
              DropdownMenuEntry(value: '', label: 'Guri'),
              DropdownMenuEntry(value: '', label: 'Rohan'),
              DropdownMenuEntry(value: '', label: 'Katherine'),
            ]
          ),

          const SizedBox(width: 30),

          GestureDetector(
            onTap: () => (),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                'Select Activity',
                style: GoogleFonts.ubuntu(fontSize: 15, color: Colors.black, letterSpacing: 1),
              ),
            ),
          ),
          
          const SizedBox(width: 30),

          GestureDetector(
            onTap: () => (),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                'Reset',
                style: GoogleFonts.ubuntu(fontSize: 15, color: Colors.black, letterSpacing: 1),
              ),
            ),
          ),

          const SizedBox(width: 30),

          IconButton(
            onPressed: signUserOut, 
            icon: const Icon(Icons.logout)
          ),

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
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(97, 161, 140, 140),
                  ),
                  child: GridView.count(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                    children: [
                      SubjectWidget(tapFunction: onToActivity, text: 'A B C', image1: const AssetImage('lib/images/abc.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Colors', image1: const AssetImage('lib/images/colors.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Shapes', image1: const AssetImage('lib/images/shapes.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Objects', image1: const AssetImage('lib/images/geography.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Food', image1: const AssetImage('lib/images/food.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: '1 2 3', image1: const AssetImage('lib/images/123.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Feeling', image1: const AssetImage('lib/images/drake.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Places',  image1: const AssetImage('lib/images/places.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Questions', image1: const AssetImage('lib/images/questions.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Prepositions', image1: const AssetImage('lib/images/prepositions.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Sight Words', image1: const AssetImage('lib/images/sight.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Actions & Verbs', image1: const AssetImage('lib/images/verbs.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Sequence', image1: const AssetImage('lib/images/sequence.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Fill Color Game', image1: const AssetImage('lib/images/colorgame.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Matching Games', image1: const AssetImage('lib/images/matching.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Tracing Games', image1: const AssetImage('lib/images/tracing.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Hoot Hoot', image1: const AssetImage('lib/images/birds.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Spelling Practice', image1: const AssetImage('lib/images/spelling.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Digital Books', image1: const AssetImage('lib/images/books.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Car Racing', image1: const AssetImage('lib/images/car_racing.jpg')),
                      SubjectWidget(tapFunction: onToActivity, text: 'Math Practice', image1: const AssetImage('lib/images/math.jpg')),
                    ],
                  ),
                ),
              ),       
              // End Guri
                    
              // Start Danny    
              Row(
                children: [
                  SoundButton(tapFunction: ()=> (), text: 'Help', desiredColor: Colors.orange),
                  const SizedBox(width: 20),
                  SoundButton(tapFunction: ()=> (), text: 'Yes', desiredColor: Colors.green),
                  const SizedBox(width:20),
                  SoundButton(tapFunction: ()=> (), text: 'No', desiredColor: Colors.red),
                ],
              ),       
              // End Danny
            ],
          ),

        // Start Rohan
          Container(
            padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).height * 0.10),
            // child: Text("Rohan"),
            child: Column(
              children: [
                Text(
                  '${time.hour}:${time.minute}',
                  style: GoogleFonts.ubuntu(fontSize:40, color:Colors.black, letterSpacing: 2),
                ),
                SubjectWidget(tapFunction: onToActivity, text: 'Previous', image1: const AssetImage('lib/images/places.jpg')),
                const SizedBox(height: 20,),
                SubjectWidget(tapFunction: onToActivity, text: 'Current', image1: const AssetImage('lib/images/geography.jpg')),
                const SizedBox(height: 20,),
                SubjectWidget(tapFunction: onToActivity, text: 'Next', image1: const AssetImage('lib/images/sight.jpg')),

              ],
            )
          )

        // End Rohan
        ],
      ),

    );
  }
}