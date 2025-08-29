import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_clock/one_clock.dart';
import 'package:verbalautism/activities/abc/base_page/abc.dart';
import 'package:verbalautism/activities/actions/base_page/actions_base_page.dart';
import 'package:verbalautism/activities/colors/base_page/colors_base_page.dart';
import 'package:verbalautism/activities/feelings/base_page/feelings_base_page.dart';
import 'package:verbalautism/activities/food/base_page/food_base_page.dart';
import 'package:verbalautism/activities/numbers/base_page/numbers.dart';
import 'package:verbalautism/activities/objects/base_page/objects_base_page.dart';
import 'package:verbalautism/activities/places/base_page/places_base_page.dart';
import 'package:verbalautism/activities/shapes/base_page/shapes_base_page.dart';
import 'package:verbalautism/activities/sight_word/base_page/sight_word_base_page.dart';
import 'package:verbalautism/components/audio%20services/audio_cubit.dart';
import 'package:verbalautism/components/audio%20services/audio_service.dart';
import 'package:verbalautism/components/home%20page%20components/buttons_column.dart';
import 'package:verbalautism/components/home%20page%20components/schedule_button.dart';
import 'package:verbalautism/components/home%20page%20components/sound_button.dart';
import 'package:verbalautism/components/home%20page%20components/subject_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/features/auth/presentation/cubits/auth_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  AudioCubit audioCubit = AudioCubit();
  late bool isMusicPlaying = audioCubit.state.isMusicPlaying;

  // Sign out method
  void signUserOut(){
    final authCubit = context.read<AuthCubit>();
    authCubit.logout();
  }

  @override
  void initState() {
    AudioService().playBackgroundMusic(); // if music is enabled, play music
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool isSmallWidth(BuildContext context) =>
      screenWidth <= 920;

    double rightSideLength(){
      if(screenWidth <= 630){
        return screenWidth * 0;
      } else if(screenWidth <= 730){
        return screenWidth * 0.005;
      }
      else if(screenWidth <= 800){
        return screenWidth * 0.02;
      }
      else if(screenWidth <= 920){
        return screenWidth * 0.025;
      } else {
        return screenWidth * 0.05;
      }
    }

    double smallFont() {
      if(screenWidth <= 920 && screenWidth > 720){
        return 1;
      } else if(screenWidth <= 720){
        return 0.9;
      } else {
        return 1.25;
      }
    }

    void onToAlphabet(){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const Activity1()
        )
      );
    }

    void onToNumbers(){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const Numbers()
        )
      );
    }

    void onToColors(){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const ColorsBasePage()
        )
      );
    }

    void onToShapes(){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const ShapesBasePage()
        )
      );
    }

    void onToObjects(){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const ObjectsBasePage()
        )
      );
    }

    void onToFood(){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const FoodBasePage()
        )
      );
    }

    void onToPlaces(){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const PlacesBasePage()
        )
      );
    }

    void onToFeelings(){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const FeelingsBasePage()
        )
      );
    }
  
    void onToActions(){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const ActionsBasePage()
        )
      );
    }

    void onToSightWords(){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const SightWordBasePage()
        )
      );
    }
    
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          titleSpacing: 16,
          title: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Logo or empty space
                  if (screenWidth > 900)
                    const Image(
                      image: AssetImage('assets/homepage_images/appbarlogo.png'),
                      height: 60,
                    ),

                  const SizedBox(width: 5,),

                  // Right: Wrap all the elements, so spacing adjusts on its own
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ScheduleButton(tapFunction: () {}),

                        // Music Control
                        IconButton(
                          icon: isMusicPlaying 
                            ? const Icon(Icons.music_note) 
                            : const Icon(Icons.music_off),
                          onPressed: () {
                            audioCubit.toggleMusic();

                            if (audioCubit.state.isMusicPlaying) {
                              AudioService().playBackgroundMusic();
                            } else {
                              AudioService().stopMusic();
                            }

                            setState(() {
                              isMusicPlaying = audioCubit.state.isMusicPlaying;
                            });
                          },
                        ),

                        IconButton(icon: const Icon(Icons.leaderboard), onPressed: () {}),

                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton(
                            onPressed: () => {},
                            child: Text(
                              'Select Activity',
                              style: GoogleFonts.ubuntu(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),


                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton(
                            onPressed: () => {},
                            child: Text(
                              'Reset',
                              style: GoogleFonts.ubuntu(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),

                        // Logout
                        IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout)),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),

        
        // Main Body
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 10,),

            // Left Buttons Column
            const ButtonsColumn(),


            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                // Middle Area
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.7,
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 33, 150, 243),
                    ),
                    child: GridView.count(
                      crossAxisCount: isSmallWidth(context) ? 3 : 4,
                      childAspectRatio: 1.75,
                      children: [
                        SubjectWidget(tapFunction: onToAlphabet, text: 'A B C', image1: const AssetImage('assets/homepage_images/abc.jpg')),
                        SubjectWidget(tapFunction: onToColors, text: 'Colors', image1: const AssetImage('assets/homepage_images/colors.jpg')),
                        SubjectWidget(tapFunction: onToShapes, text: 'Shapes', image1: const AssetImage('assets/homepage_images/shapes.jpg')),
                        SubjectWidget(tapFunction: onToObjects, text: 'Objects', image1: const AssetImage('assets/homepage_images/geography.jpg')),
                        SubjectWidget(tapFunction: onToFood, text: 'Food', image1: const AssetImage('assets/homepage_images/food.jpg')),
                        SubjectWidget(tapFunction: onToNumbers,  text: '1 2 3', image1: const AssetImage('assets/homepage_images/123.jpg')),
                        SubjectWidget(tapFunction: onToFeelings, text: 'Feeling', image1: const AssetImage('assets/homepage_images/flowers.jpg')),
                        SubjectWidget(tapFunction: onToPlaces, text: 'Places',  image1: const AssetImage('assets/homepage_images/places.jpg')),
                        SubjectWidget(tapFunction: onToSightWords, text: 'Sight Words', image1: const AssetImage('assets/homepage_images/sight.jpg')),
                        SubjectWidget(tapFunction: onToActions, text: 'Action Verbs', image1: const AssetImage('assets/homepage_images/verbs.jpg')),
                      ],
                    ),
                  ),
                ),

                // Bottom Area 
                const Row(
                  children: [
                    SoundButton(text: 'Help', desiredColor: Colors.orange, audioAsset: "audio_files/help.mp3",),
                    SizedBox(width: 20),
                    SoundButton(text: 'Yes', desiredColor: Colors.green, audioAsset: "audio_files/yes.mp3",),
                    SizedBox(width:20),
                    SoundButton(text: 'No', desiredColor: Colors.red, audioAsset: "audio_files/no.mp3"),
                  ],
                ),       
              ],
            ),

            // Right Area
            SafeArea(
              child: Container(
                padding: EdgeInsets.only(left: rightSideLength()),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      DigitalClock(
                        showSeconds: false,
                        isLive: true,
                        digitalClockTextColor: Colors.white,
                        textScaleFactor: smallFont(),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 33, 150, 243),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                          datetime: DateTime.now(),
                      ),
                      
                      SubjectWidget(
                        tapFunction: onToAlphabet, 
                        text: 'Previous', 
                        image1: const AssetImage('assets/homepage_images/places.jpg'), 
                        width: screenWidth * 0.1, height: screenHeight * 0.2
                      ),

                      const SizedBox(height: 10,),

                      SubjectWidget(
                        tapFunction: onToAlphabet, 
                        text: 'Current', 
                        image1: const AssetImage('assets/homepage_images/geography.jpg'),
                        width: screenWidth * 0.1, 
                        height: screenHeight * 0.2
                      
                      ),
                      
                      const SizedBox(height: 10,),

                      SubjectWidget(
                        tapFunction: onToAlphabet, 
                        text: 'Next', 
                        image1: const AssetImage('assets/homepage_images/sight.jpg'),
                        width: screenWidth* 0.1, 
                        height: screenHeight * 0.2
                      ),
                                
                    ],
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}