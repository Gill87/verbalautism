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
      formattedDate = '${date.month}/${date.day}/${date.year}';
    }

    // Use LayoutBuilder to get available space
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 200;
        final isVeryNarrow = constraints.maxWidth < 160;
        
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(isVeryNarrow ? 8.0 : 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with game type
                _buildHeader(formattedGameType, isNarrow, isVeryNarrow),
                SizedBox(height: isVeryNarrow ? 4 : 8),
                
                // Date
                if (!isVeryNarrow) _buildDateSection(formattedDate, isNarrow),
                if (!isVeryNarrow) SizedBox(height: isNarrow ? 4 : 8),

                // Rounds played
                _buildRoundsSection(roundsPlayed, isNarrow, isVeryNarrow),
                SizedBox(height: isVeryNarrow ? 4 : 8),

                // Stats - adapt layout based on width
                if (isVeryNarrow)
                  _buildCompactStats(correct, incorrect, averageDuration, accuracy)
                else if (isNarrow)
                  _buildNarrowStats(correct, incorrect, averageDuration, accuracy)
                else
                  _buildFullStats(correct, incorrect, averageDuration, accuracy),

                SizedBox(height: isVeryNarrow ? 12 : 16),

                // Progress bar for accuracy
                _buildAccuracyBar(accuracy, isVeryNarrow),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(String formattedGameType, bool isNarrow, bool isVeryNarrow) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isVeryNarrow ? 4 : 6, 
        vertical: isVeryNarrow ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: _getGameTypeColor(gameType),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        formattedGameType.toUpperCase(),
        style: GoogleFonts.ubuntu(
          color: Colors.white,
          fontSize: isVeryNarrow ? 9 : (isNarrow ? 10 : 11),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDateSection(String formattedDate, bool isNarrow) {
    return Text(
      formattedDate,
      style: GoogleFonts.ubuntu(
        fontSize: isNarrow ? 10 : 11,
        color: Colors.grey[600],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildRoundsSection(int roundsPlayed, bool isNarrow, bool isVeryNarrow) {
    return Row(
      children: [
        Icon(
          Icons.play_circle_outline, 
          size: isVeryNarrow ? 12 : 14, 
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            isVeryNarrow ? '$roundsPlayed rounds' : 'Rounds: $roundsPlayed',
            style: GoogleFonts.ubuntu(
              fontSize: isVeryNarrow ? 10 : (isNarrow ? 11 : 12),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStats(int correct, int incorrect, double averageDuration, double accuracy) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCompactStatItem('✓', correct.toString(), Colors.green),
            _buildCompactStatItem('✗', incorrect.toString(), Colors.red),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${averageDuration.toStringAsFixed(1)}s avg',
          style: GoogleFonts.ubuntu(
            fontSize: 9,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.ubuntu(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.ubuntu(
            fontSize: 9,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowStats(int correct, int incorrect, double averageDuration, double accuracy) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNarrowStatItem(Icons.check, correct.toString(), Colors.green),
            _buildNarrowStatItem(Icons.close, incorrect.toString(), Colors.red),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Avg: ${averageDuration.toStringAsFixed(1)}s',
          style: GoogleFonts.ubuntu(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowStatItem(IconData icon, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.ubuntu(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFullStats(int correct, int incorrect, double averageDuration, double accuracy) {
    return Row(
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
            icon: Icons.timer,
            label: 'Avg Time',
            value: '${averageDuration.toStringAsFixed(1)}s',
            color: Colors.grey[600]!,
          ),
        ),
      ],
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
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.ubuntu(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: GoogleFonts.ubuntu(
            fontSize: 10,
            color: Colors.grey[600],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAccuracyBar(double accuracy, bool isVeryNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.bar_chart, 
              size: isVeryNarrow ? 12 : 14, 
              color: _getAccuracyColor(accuracy),
            ),
            const SizedBox(width: 4),
            Text(
              'Accuracy: ${accuracy.toStringAsFixed(1)}%',
              style: GoogleFonts.ubuntu(
                fontSize: isVeryNarrow ? 10 : 12,
                color: _getAccuracyColor(accuracy),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          minHeight: isVeryNarrow ? 4 : 6,
          borderRadius: BorderRadius.circular(8),
          value: accuracy / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(_getAccuracyColor(accuracy)),
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