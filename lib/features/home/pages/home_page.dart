import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_clock/one_clock.dart';
import 'package:verbalautism/activities/abc/base_page/abc.dart';
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

    // Is Desktop
    bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1000;

    void onToActivity(){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const Activity1()
        )
      );
    }
  
    return SafeArea(
      child: Scaffold(
      
        appBar: AppBar(
          
          // Logo
          title: const Image(image: AssetImage('lib/images/homepage_images/appbarlogo.png'), height: 100,),
      
          toolbarHeight: 80,
      
          actions: [
            
            // Cash
            const Image(image: AssetImage('lib/images/homepage_images/cash.png')),
            Text(
              '= \$200',  // Money Feature Needed
              style: GoogleFonts.ubuntu(color: Colors.green[500], fontSize: 18),
              ),
      
            const SizedBox(width: 40,),
            
            // Schedule Button
            ScheduleButton(tapFunction: () => ()),
      
            const SizedBox(width: 30),     
      
            // Music Toggle
            IconButton(
              icon: const Icon(Icons.music_note),
              onPressed: () => (),
            ),
            
            const SizedBox(width: 30),     

            // Leaderboard Button
            IconButton(
              icon: const Icon(Icons.leaderboard),
              onPressed: () => (),
            ),
      
            const SizedBox(width: 30),

            // Select Student Dropdown
            const DropdownMenu(
              dropdownMenuEntries: <DropdownMenuEntry<String>>[
                DropdownMenuEntry(value: '', label: 'Danny'),
                DropdownMenuEntry(value: '', label: 'Guri'),
                DropdownMenuEntry(value: '', label: 'Rohan'),
                DropdownMenuEntry(value: '', label: 'Katherine'),
              ]
            ),
      
            const SizedBox(width: 30),

            // Select Activity
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

            // Reset
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

            // Sign out button
            IconButton(
              onPressed: signUserOut, 
              icon: const Icon(Icons.logout)
            ),
      
          ],
        ),
        
        // Main Body
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                      
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
                        SubjectWidget(tapFunction: onToActivity, text: 'A B C', image1: const AssetImage('lib/images/homepage_images/abc.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Colors', image1: const AssetImage('lib/images/homepage_images/colors.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Shapes', image1: const AssetImage('lib/images/homepage_images/shapes.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Objects', image1: const AssetImage('lib/images/homepage_images/geography.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Food', image1: const AssetImage('lib/images/homepage_images/food.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: '1 2 3', image1: const AssetImage('lib/images/homepage_images/123.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Feeling', image1: const AssetImage('lib/images/homepage_images/drake.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Places',  image1: const AssetImage('lib/images/homepage_images/places.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Questions', image1: const AssetImage('lib/images/homepage_images/questions.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Prepositions', image1: const AssetImage('lib/images/homepage_images/prepositions.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Sight Words', image1: const AssetImage('lib/images/homepage_images/sight.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Actions & Verbs', image1: const AssetImage('lib/images/homepage_images/verbs.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Sequence', image1: const AssetImage('lib/images/homepage_images/sequence.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Fill Color Game', image1: const AssetImage('lib/images/homepage_images/colorgame.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Matching Games', image1: const AssetImage('lib/images/homepage_images/matching.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Tracing Games', image1: const AssetImage('lib/images/homepage_images/tracing.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Hoot Hoot', image1: const AssetImage('lib/images/homepage_images/birds.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Spelling Practice', image1: const AssetImage('lib/images/homepage_images/spelling.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Digital Books', image1: const AssetImage('lib/images/homepage_images/books.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Car Racing', image1: const AssetImage('lib/images/homepage_images/car_racing.jpg')),
                        SubjectWidget(tapFunction: onToActivity, text: 'Math Practice', image1: const AssetImage('lib/images/homepage_images/math.jpg')),
                      ],
                    ),
                  ),
                ),       
                      
                Row(
                  children: [
                    SoundButton(tapFunction: ()=> (), text: 'Help', desiredColor: Colors.orange),
                    const SizedBox(width: 20),
                    SoundButton(tapFunction: ()=> (), text: 'Yes', desiredColor: Colors.green),
                    const SizedBox(width:20),
                    SoundButton(tapFunction: ()=> (), text: 'No', desiredColor: Colors.red),
                  ],
                ),       
              ],
            ),
      
            SafeArea(
              child: Container(
                padding: isDesktop(context) 
                            ? EdgeInsets.only(left: MediaQuery.sizeOf(context).height * 0.1)
                            : EdgeInsets.only(left: MediaQuery.sizeOf(context).height * 0.05),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DigitalClock(
                        showSeconds: false,
                        isLive:false,
                        digitalClockTextColor: Colors.white,
                        textScaleFactor: 1.25,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                          datetime: DateTime.now(),
                      ),
                      
                      SubjectWidget(tapFunction: onToActivity, text: 'Previous', image1: const AssetImage('lib/images/homepage_images/places.jpg')),
                      const SizedBox(height: 10,),
                      SubjectWidget(tapFunction: onToActivity, text: 'Current', image1: const AssetImage('lib/images/homepage_images/geography.jpg')),
                      const SizedBox(height: 10,),
                      SubjectWidget(tapFunction: onToActivity, text: 'Next', image1: const AssetImage('lib/images/homepage_images/sight.jpg')),
                                
                    ],
                  ),
                )
              ),
            )
      
          // End Rohan
          ],
        ),
      
      ),
    );
  }
}