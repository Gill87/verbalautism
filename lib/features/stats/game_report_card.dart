import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameReportCard extends StatelessWidget {
  final Map<String, dynamic> reportData;
  final String gameType;

  const GameReportCard({
    super.key,
    required this.reportData,
    required this.gameType,
  });

  // Insert spaces before capital letters and capitalize the first letter
  String formatGameType(String type) {
    return type.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    }).replaceFirst(type[0], type[0].toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    final correct = reportData['correct'] ?? 0;
    final incorrect = reportData['incorrect'] ?? 0;
    final total = correct + incorrect;
    final accuracy = total > 0 ? (correct / total * 100) : 0;
    final roundsPlayed = reportData['roundsPlayed'] ?? 0;
    final averageDuration = reportData['averageDuration'] ?? 0.0;
    final createdAt = reportData['createdAt'] as Timestamp?;
    
    String formattedGameType = formatGameType(gameType);

    // Format the date
    String formattedDate = 'No reports yet';
    if (createdAt != null) {
      final date = createdAt.toDate();
      formattedDate = 'Last played: ${date.month}/${date.day}/${date.year}';
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
                    formattedGameType.toUpperCase(),
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
            
            // Rounds played
            Row(
              children: [

                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.play_circle_outline, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Rounds Played: $roundsPlayed',
                        style: GoogleFonts.ubuntu(fontSize: 14),
                      ),
                    ],
                  ),
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
      case 'lowercaseletters':
        return Colors.orange;
      case 'uppercaseletters':
        return Colors.teal;
      case 'mixedletters':
        return Colors.indigo;
      case 'actions':
        return Colors.pink;
      case 'colors':
        return Colors.cyan;
      case 'feelings':
        return Colors.amber;
      case 'foods':
        return Colors.green;
      case 'numbers':
        return Colors.red;
      case 'shapes':
        return Colors.brown;
      case 'objects':
        return Colors.deepOrange;
      case 'places':
        return Colors.lime;
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