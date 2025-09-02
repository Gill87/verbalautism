import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        // Add more potential game types as needed
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
            const SizedBox(height: 16),
            if (isLoadingGameTypes)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (gameTypes.isEmpty)
              Card(
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
              )
            else
              ...gameTypes.map((gameType) => GameTypeSection(
                gameType: gameType,
                userId: user.uid,
              )).toList(),
          ],
        ),
      ),
    );
  }
}

class GameTypeSection extends StatelessWidget {
  final String gameType;
  final String userId;

  const GameTypeSection({
    super.key,
    required this.gameType,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '${gameType.toUpperCase()} Reports',
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("${gameType}Reports")
              .orderBy("createdAt", descending: true)
              .limit(10) // Limit to recent 10 reports
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No ${gameType} reports found',
                    style: GoogleFonts.ubuntu(color: Colors.grey[600]),
                  ),
                ),
              );
            }

            return Column(
              children: snapshot.data!.docs.map((doc) {
                return GameReportCard(
                  reportData: doc.data() as Map<String, dynamic>,
                  gameType: gameType,
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class GameReportCard extends StatelessWidget {
  final Map<String, dynamic> reportData;
  final String gameType;

  const GameReportCard({
    super.key,
    required this.reportData,
    required this.gameType,
  });

  @override
  Widget build(BuildContext context) {
    final correct = reportData['correct'] ?? 0;
    final incorrect = reportData['incorrect'] ?? 0;
    final total = correct + incorrect;
    final accuracy = total > 0 ? (correct / total * 100) : 0;
    final round = reportData['round'] ?? 0;
    final averageDuration = reportData['averageDuration'] ?? 0.0;
    final word = reportData['word'] ?? 'Unknown';
    final createdAt = reportData['createdAt'] as Timestamp?;
    
    // Format the date
    String formattedDate = 'Unknown date';
    if (createdAt != null) {
      final date = createdAt.toDate();
      formattedDate = '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with game type and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getGameTypeColor(gameType),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    gameType.toUpperCase(),
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: GoogleFonts.ubuntu(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Word/Content
            if (word != 'Unknown')
              Row(
                children: [
                  Icon(Icons.text_fields, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Word: $word',
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            
            // Round number
            Row(
              children: [
                Icon(Icons.refresh, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Round: $round',
                  style: GoogleFonts.ubuntu(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.check_circle,
                    label: 'Correct',
                    value: correct.toString(),
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.cancel,
                    label: 'Incorrect',
                    value: incorrect.toString(),
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.percent,
                    label: 'Accuracy',
                    value: '${accuracy.toStringAsFixed(1)}%',
                    color: _getAccuracyColor(accuracy),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Average duration
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Avg Duration: ${averageDuration.toStringAsFixed(1)}s',
                  style: GoogleFonts.ubuntu(fontSize: 14),
                ),
              ],
            ),
            
            // Progress bar for accuracy
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: accuracy / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_getAccuracyColor(accuracy)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.ubuntu(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.ubuntu(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getGameTypeColor(String gameType) {
    switch (gameType.toLowerCase()) {
      case 'sightword':
        return Colors.purple;
      case 'math':
        return Colors.orange;
      case 'reading':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }
}