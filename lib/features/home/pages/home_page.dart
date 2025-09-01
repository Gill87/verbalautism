import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_clock/one_clock.dart';
import 'package:verbalautism/activities/abc/base_page/abc_base_page.dart';
import 'package:verbalautism/activities/actions/base_page/actions_base_page.dart';
import 'package:verbalautism/activities/colors/base_page/colors_base_page.dart';
import 'package:verbalautism/activities/feelings/base_page/feelings_base_page.dart';
import 'package:verbalautism/activities/food/base_page/food_base_page.dart';
import 'package:verbalautism/activities/numbers/base_page/numbers.dart';
import 'package:verbalautism/activities/objects/base_page/objects_base_page.dart';
import 'package:verbalautism/activities/places/base_page/places_base_page.dart';
import 'package:verbalautism/activities/shapes/base_page/shapes_base_page.dart';
import 'package:verbalautism/activities/sight_word/base_page/sight_word_base_page.dart';
import 'package:verbalautism/components/audio%20services/audio_service.dart';
import 'package:verbalautism/components/home%20page%20components/buttons_column.dart';
import 'package:verbalautism/components/home%20page%20components/schedule_button.dart';
import 'package:verbalautism/components/home%20page%20components/schedule_summary.dart';
import 'package:verbalautism/components/home%20page%20components/sound_button.dart';
import 'package:verbalautism/components/home%20page%20components/selectable_subject_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:verbalautism/features/schedule/schedule_calendar_page.dart';
import 'package:verbalautism/features/stats/stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late bool isMusicPlaying = AudioService().isMusicPlaying;
  bool adminAccess = false;

  // Selection state management
  bool isSelectionMode = false;

  // Selected Activites Data Structure that can be changed
  Set<String> selectedActivities = {
    'ABC', 'Colors', 'Shapes', 'Objects', 'Food', 
    'Numbers', 'Feelings', 'Places', 'Sight Words', 'Action Verbs'
  };
  
  static const List<String> allActivities = [
    'ABC', 'Colors', 'Shapes', 'Objects', 'Food', 
    'Numbers', 'Feelings', 'Places', 'Sight Words', 'Action Verbs'
  ];

  // Activity data structure
  final List<Map<String, dynamic>> activityData = [
    {
      'name': 'ABC',
      'text': 'A B C',
      'image': 'assets/homepage_images/abc.jpg',
      'onTap': 'onToAlphabet'
    },
    {
      'name': 'Colors',
      'text': 'Colors',
      'image': 'assets/homepage_images/colors.jpg',
      'onTap': 'onToColors'
    },
    {
      'name': 'Shapes',
      'text': 'Shapes',
      'image': 'assets/homepage_images/shapes.jpg',
      'onTap': 'onToShapes'
    },
    {
      'name': 'Objects',
      'text': 'Objects',
      'image': 'assets/homepage_images/geography.jpg',
      'onTap': 'onToObjects'
    },
    {
      'name': 'Food',
      'text': 'Food',
      'image': 'assets/homepage_images/food.jpg',
      'onTap': 'onToFood'
    },
    {
      'name': 'Numbers',
      'text': '1 2 3',
      'image': 'assets/homepage_images/123.jpg',
      'onTap': 'onToNumbers'
    },
    {
      'name': 'Feelings',
      'text': 'Feeling',
      'image': 'assets/homepage_images/flowers.jpg',
      'onTap': 'onToFeelings'
    },
    {
      'name': 'Places',
      'text': 'Places',
      'image': 'assets/homepage_images/places.jpg',
      'onTap': 'onToPlaces'
    },
    {
      'name': 'Sight Words',
      'text': 'Sight Words',
      'image': 'assets/homepage_images/sight.jpg',
      'onTap': 'onToSightWords'
    },
    {
      'name': 'Action Verbs',
      'text': 'Action Verbs',
      'image': 'assets/homepage_images/verbs.jpg',
      'onTap': 'onToActions'
    },
  ];

  // Sign out method
  void signUserOut(){
    final authCubit = context.read<AuthCubit>();
    AudioService().stopMusic();
    authCubit.logout();
  }

  // Selection mode methods
  void enterSelectionMode() {
    setState(() {
      isSelectionMode = true;
    });
  }

  void exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
    });
  }

  void toggleActivitySelection(String activityName) {
    setState(() {
      if (selectedActivities.contains(activityName)) {
        selectedActivities.remove(activityName);
      } else {
        selectedActivities.add(activityName);
      }
    });
  }

  void resetActivities() {
    setState(() {
      selectedActivities = Set.from(allActivities);
      isSelectionMode = false;
    });
  }

  void applySelection() {
    // Ensure at least one activity is selected
    if (selectedActivities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one activity'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    exitSelectionMode();
  }

  Future<void> adminAccessDialog() async {
    final TextEditingController controller = TextEditingController();
    bool showError = false;

    await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            
            return AlertDialog(
              backgroundColor: Colors.blue,
              title: Text(
                "Admin Access Needed",
                style: GoogleFonts.ubuntu(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    cursorColor: Colors.white,
                    style: GoogleFonts.ubuntu(color: Colors.white),
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Enter User Email",
                      hintStyle: GoogleFonts.ubuntu(color: Colors.white),
                      errorText: showError ? 'Incorrect email address' : null,
                      errorStyle: GoogleFonts.ubuntu(color: Colors.red[300]),
                    ),
                  ),

                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // cancel
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.ubuntu(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text == user.email) {
                      setState(() {
                        adminAccess = true;
                      });
                      Navigator.pop(context);
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Admin access granted successfully!',
                            style: GoogleFonts.ubuntu(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      // Show error inline
                      setDialogState(() {
                        showError = true;
                      });
                      // Clear error after 2 seconds
                      Future.delayed(const Duration(seconds: 2), () {
                        if (context.mounted) {
                          setDialogState(() {
                            showError = false;
                          });
                        }
                      });
                    }
                  },
                  child: Text(
                    "Get Admin Access",
                    style: GoogleFonts.ubuntu(color: Colors.black),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    AudioService().playBackgroundMusic(); // if music is enabled, play music
    super.initState();
  }

  // Navigation methods
  void onToAlphabet(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AbcBasePage()));
  }

  void onToNumbers(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Numbers()));
  }

  void onToColors(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ColorsBasePage()));
  }

  void onToShapes(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ShapesBasePage()));
  }

  void onToObjects(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ObjectsBasePage()));
  }

  void onToFood(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodBasePage()));
  }

  void onToPlaces(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlacesBasePage()));
  }

  void onToFeelings(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FeelingsBasePage()));
  }

  void onToActions(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ActionsBasePage()));
  }

  void onToSightWords(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SightWordBasePage()));
  }

  // Get navigation function by name
  Function()? getNavigationFunction(String functionName) {
    switch (functionName) {
      case 'onToAlphabet': return onToAlphabet;
      case 'onToNumbers': return onToNumbers;
      case 'onToColors': return onToColors;
      case 'onToShapes': return onToShapes;
      case 'onToObjects': return onToObjects;
      case 'onToFood': return onToFood;
      case 'onToPlaces': return onToPlaces;
      case 'onToFeelings': return onToFeelings;
      case 'onToActions': return onToActions;
      case 'onToSightWords': return onToSightWords;
      default: return null;
    }
  }

  // Filter activities based on selection
  List<Map<String, dynamic>> getVisibleActivities() {
    return activityData.where((activity) => 
      selectedActivities.contains(activity['name'])
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    bool isSmallWidth(BuildContext context) => screenWidth <= 920;

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
                        // Schedule Button
                        ScheduleButton(
                          tapFunction: () {
                            if(adminAccess){
                              onScheduleButtonTap(context);
                            } else {
                              adminAccessDialog();
                            }
                          }
                        ),

                        // Music Control
                        IconButton(
                          icon: isMusicPlaying 
                            ? const Icon(Icons.music_note) 
                            : const Icon(Icons.music_off),
                          onPressed: () {
                            setState(() {
                              AudioService().toggleMusic();
                              isMusicPlaying = AudioService().isMusicPlaying;
                            });
                          },
                        ),

                        // Stats Button
                        IconButton(
                          icon: const Icon(Icons.leaderboard), 
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => const StatsPage()
                              )
                            );
                          }
                        ),

                        // Select Activity Button
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton(
                            onPressed: () {
                              if(adminAccess){
                                isSelectionMode ? null : enterSelectionMode();
                              } else {
                                adminAccessDialog();
                              }
                            },
                            child: Text(
                              'Select Activity',
                              style: GoogleFonts.ubuntu(
                                fontSize: 16, 
                                color: isSelectionMode ? Colors.grey : Colors.black
                              ),
                            ),
                          ),
                        ),

                        // Reset Button
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton(
                            onPressed: () {
                              if(adminAccess){
                                isSelectionMode ? null : resetActivities();
                              } else {
                                adminAccessDialog();
                              }
                            },
                            child: Text(
                              'Reset',
                              style: GoogleFonts.ubuntu(
                                fontSize: 16, 
                                color: isSelectionMode ? Colors.grey : Colors.black
                              ),
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
        body: Column(
          children: [
            // Selection mode controls
            if (isSelectionMode)
              Container(
                width: double.infinity,
                color: Colors.blue.shade100,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select activities to show (${selectedActivities.length}/${allActivities.length} selected)',
                      style: GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: applySelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Done', style: GoogleFonts.ubuntu()),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: exitSelectionMode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Cancel', style: GoogleFonts.ubuntu()),
                    ),
                  ],
                ),
              ),

            // Main content
            Expanded(
              child: Row(
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
                            children: _buildActivityWidgets(),
                          ),
                        ),
                      ),

                      // Bottom Area 
                      if (!isSelectionMode)
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
                            
                            const SizedBox(height: 20,),

                            const ScheduleSummary(),
                                      
                          ],
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActivityWidgets() {
    final activitiesToShow = isSelectionMode ? activityData : getVisibleActivities();

    return activitiesToShow.map((activity) {
      return SelectableSubjectWidget(
        tapFunction: isSelectionMode 
          ? () => toggleActivitySelection(activity['name'])
          : getNavigationFunction(activity['onTap']),
        text: activity['text'],
        image1: AssetImage(activity['image']),
        isSelectionMode: isSelectionMode,
        isSelected: selectedActivities.contains(activity['name']),
        activityName: activity['name'],
      );
    }).toList();
  }
}