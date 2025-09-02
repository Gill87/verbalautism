import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/features/stats/game_report_card.dart';

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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("${gameType}Reports")
          .orderBy("createdAt", descending: true)
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
    
        // Aggregate all the data for this game type
        final aggregatedData = _aggregateGameData(snapshot.data!.docs);
        
        return GameReportCard(
          reportData: aggregatedData,
          gameType: gameType,
        );
      },
    );
  }

  Map<String, dynamic> _aggregateGameData(List<QueryDocumentSnapshot> docs) {
    if (docs.isEmpty) return {};
    
    int totalCorrect = 0;
    int totalIncorrect = 0;
    double totalDuration = 0.0;
    int roundsPlayed = docs.length;
    Timestamp? mostRecentDate;
    
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      
      totalCorrect += (data['correct'] as int? ?? 0);
      totalIncorrect += (data['incorrect'] as int? ?? 0);
      totalDuration += (data['averageDuration'] as num? ?? 0).toDouble();
      
      // Track most recent date
      final createdAt = data['createdAt'] as Timestamp?;
      if (createdAt != null) {
        if (mostRecentDate == null || createdAt.compareTo(mostRecentDate) > 0) {
          mostRecentDate = createdAt;
        }
      }
    }
    
    return {
      'correct': totalCorrect,
      'incorrect': totalIncorrect,
      'roundsPlayed': roundsPlayed,
      'averageDuration': roundsPlayed > 0 ? totalDuration / roundsPlayed : 0.0,
      'createdAt': mostRecentDate,
    };
  }
}