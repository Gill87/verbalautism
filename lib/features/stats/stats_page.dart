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
      // Get all subcollections under the user document
      final userDocRef = _firestore.collection("users").doc(user.uid);
      
      // Unfortunately, Firestore doesn't have a direct way to list subcollections
      // So we'll try common game report patterns and check if they have documents
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
          // Remove 'Reports' suffix to get clean game type name
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
    
    // Calculate days since Sunday (0 = Sunday, 1 = Monday, etc.)
    int daysSinceSunday = now.weekday % 7; // Convert to 0-6 where 0 is Sunday
    
    // Get the Sunday of current week
    final sunday = now.subtract(Duration(days: daysSinceSunday));
    
    // Get the Saturday of current week (6 days after Sunday)
    final saturday = sunday.add(const Duration(days: 6));
    
    // Format dates as MM/dd
    String formatDate(DateTime date) {
      return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    }
    
    return 'Game Reports for ${formatDate(sunday)} - ${formatDate(saturday)}';
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Weekly Stats Overview', 
              style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
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
        title: Text('Weekly Stats Overview', 
            style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                getWeeklyDateRange(),
                style: GoogleFonts.ubuntu(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoadingGameTypes)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
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
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.75, // Adjust this to make cards taller/shorter
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
      ),
    );
  }
}