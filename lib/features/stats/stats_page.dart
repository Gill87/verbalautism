import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:verbalautism/features/stats/game_type_section.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> gameTypes = [];
  bool isLoadingGameTypes = true;

  @override
  void initState() {
    super.initState();
    _discoverGameTypes();
  }

  Future<void> _discoverGameTypes() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final userDocRef = _firestore.collection("users").doc(user.uid);
      
      final potentialGameTypes = [
        'sightWordReports',
        'lowercaseLettersReports',
        'uppercaseLettersReports',
        'mixedLettersReports',
        'actionsReports',
        'colorsReports',
        'feelingsReports',
        'foodsReports',
        'numbersReports',
        'shapesReports',
        'objectsReports',
        'placesReports',
      ];

      List<String> foundGameTypes = [];

      for (String gameType in potentialGameTypes) {
        final querySnapshot = await userDocRef
            .collection(gameType)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          String cleanGameType = gameType.replaceAll('Reports', '');
          foundGameTypes.add(cleanGameType);
        }
      }

      setState(() {
        gameTypes = foundGameTypes;
        isLoadingGameTypes = false;
      });
    } catch (e) {
      print('Error discovering game types: $e');
      setState(() {
        isLoadingGameTypes = false;
      });
    }
  }

  String getWeeklyDateRange() {
    final now = DateTime.now();
    int daysSinceSunday = now.weekday % 7;
    final sunday = now.subtract(Duration(days: daysSinceSunday));
    final saturday = sunday.add(const Duration(days: 6));

    String formatDate(DateTime date) {
      return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    }

    return 'Game Reports for ${formatDate(sunday)} - ${formatDate(saturday)}';
  }

  // Calculate the number of columns based on screen width
  int _calculateColumns(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 500) return 2;
    return 1;
  }

  // Calculate the aspect ratio based on screen width
  double _calculateAspectRatio(double width) {
    if (width > 800) return 1.1;
    if (width > 500) return 1.0;
    return 0.9;
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Weekly Stats Overview',
            style: GoogleFonts.ubuntu(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: Text('Please log in to view stats'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weekly Stats Overview',
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final columns = _calculateColumns(screenWidth);
            final aspectRatio = _calculateAspectRatio(screenWidth);
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with responsive font size
                  Center(
                    child: Text(
                      getWeeklyDateRange(),
                      style: GoogleFonts.ubuntu(
                        fontSize: screenWidth > 600 ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Loading state
                  if (isLoadingGameTypes)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  // Empty state
                  else if (gameTypes.isEmpty)
                    Center(
                      child: Card(
                        margin: const EdgeInsets.only(top: 25.0),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No game reports found',
                                style: GoogleFonts.ubuntu(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start playing games to see your stats here!',
                                style: GoogleFonts.ubuntu(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  // Grid with game types
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: gameTypes.length,
                      itemBuilder: (context, index) {
                        return GameTypeSection(
                          gameType: gameTypes[index],
                          userId: user.uid,
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}