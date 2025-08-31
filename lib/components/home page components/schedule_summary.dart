import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:verbalautism/features/schedule/schedule_event.dart';

class ScheduleSummary extends StatefulWidget {
  const ScheduleSummary({super.key});

  @override
  State<ScheduleSummary> createState() => _ScheduleSummaryState();
}

class _ScheduleSummaryState extends State<ScheduleSummary> {
  List<ScheduleEvent> _todayEvents = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadTodayEvents();
  }

  // Get current user's schedule collection reference
  CollectionReference? get _userScheduleCollection {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('schedule_events');
  }

  // Load today's events from Firestore
  Future<void> _loadTodayEvents() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      final collection = _userScheduleCollection;
      if (collection == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User not authenticated';
        });
        return;
      }

      // Debug: Check if collection exists and has documents
      final querySnapshot = await collection.get();
      print('Total documents in collection: ${querySnapshot.docs.length}');
      
      if (querySnapshot.docs.isEmpty) {
        print('No schedule events found in Firestore');
        setState(() {
          _todayEvents = [];
          _isLoading = false;
        });
        return;
      }
      
      final List<ScheduleEvent> events = [];
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      print('Looking for events on: ${today.toString()}');
      
      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          print('Processing document ${doc.id}: ${data.toString()}');
          
          // Check if required fields exist
          if (!data.containsKey('gameTitle') || 
              !data.containsKey('timeHour') || 
              !data.containsKey('timeMinute') ||
              !data.containsKey('gameRoute') ||
              !data.containsKey('date')) {
            print('Document ${doc.id} missing required fields');
            continue;
          }
          
          // Create event using the corrected fromMap method
          final event = ScheduleEvent.fromMap(doc.id, data);
          
          // Check if this event is for today
          final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
          
          print('Comparing dates - Event: ${eventDate.year}-${eventDate.month}-${eventDate.day}, Today: ${today.year}-${today.month}-${today.day}');
          
          if (eventDate.year == today.year && 
              eventDate.month == today.month && 
              eventDate.day == today.day) {
            events.add(event);
            print('✓ Added event: ${event.gameTitle} at ${event.time.hour}:${event.time.minute}');
          } else {
            print('✗ Event not for today - skipping');
          }
        } catch (e) {
          print('Error parsing event ${doc.id}: $e');
          continue;
        }
      }

      // Sort events by time
      events.sort((a, b) => a.totalMinutes.compareTo(b.totalMinutes));

      setState(() {
        _todayEvents = events;
        _isLoading = false;
      });
      
      print('Final loaded events count: ${events.length}');
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load schedule: ${e.toString()}';
      });
      print('Error loading events: $e');
    }
  }

  // Get the current activity based on time
  ScheduleEvent? get _currentActivity {
    if (_todayEvents.isEmpty) return null;
    
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    
    // Find the activity that should be happening now or the last one that passed
    ScheduleEvent? current;
    for (var event in _todayEvents) {
      if (event.totalMinutes <= currentMinutes) {
        current = event;
      } else {
        break;
      }
    }
    
    return current;
  }

  // Get the previous activity
  ScheduleEvent? get _previousActivity {
    if (_todayEvents.isEmpty) return null;
    
    final current = _currentActivity;
    if (current == null) return null;
    
    final currentIndex = _todayEvents.indexOf(current);
    return currentIndex > 0 ? _todayEvents[currentIndex - 1] : null;
  }

  // Get the next activity
  ScheduleEvent? get _nextActivity {
    if (_todayEvents.isEmpty) return null;
    
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    
    // Find the next upcoming activity
    for (var event in _todayEvents) {
      if (event.totalMinutes > currentMinutes) {
        return event;
      }
    }
    
    return null;
  }

  // Get activity image based on game route
  AssetImage _getActivityImage(String gameRoute) {
    switch (gameRoute) {
      case 'abc':
        return const AssetImage('assets/homepage_images/abc.jpg');
      case 'numbers':
        return const AssetImage('assets/homepage_images/123.jpg');
      case 'colors':
        return const AssetImage('assets/homepage_images/colors.jpg');
      case 'shapes':
        return const AssetImage('assets/homepage_images/shapes.jpg');
      case 'objects':
        return const AssetImage('assets/homepage_images/geography.jpg');
      case 'food':
        return const AssetImage('assets/homepage_images/food.jpg');
      case 'places':
        return const AssetImage('assets/homepage_images/places.jpg');
      case 'feelings':
        return const AssetImage('assets/homepage_images/flowers.jpg');
      case 'actions':
        return const AssetImage('assets/homepage_images/verbs.jpg');
      case 'sight_words':
        return const AssetImage('assets/homepage_images/sight.jpg');
      default:
        return const AssetImage('assets/homepage_images/abc.jpg');
    }
  }

  // Build activity card
  Widget _buildActivityCard({
    required String title,
    required String subtitle,
    required AssetImage image,
    required Color borderColor,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      width: screenWidth * 0.1,
      height: screenHeight * 0.2,
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.ubuntu(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build empty card for when no activity exists
  Widget _buildEmptyCard(String title, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      width: screenWidth * 0.1,
      height: screenHeight * 0.2,
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.grey.shade400,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: GoogleFonts.ubuntu(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Column(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(height: 10),
          Text(
            'Loading schedule...',
            style: GoogleFonts.ubuntu(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade400,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            'Schedule\nUnavailable',
            style: GoogleFonts.ubuntu(
              fontSize: 10,
              color: Colors.red.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadTodayEvents,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.ubuntu(fontSize: 10),
            ),
          ),
        ],
      );
    }

    final previous = _previousActivity;
    final current = _currentActivity;
    final next = _nextActivity;

    return Column(
      children: [
        // Previous Activity
        previous != null
            ? _buildActivityCard(
                title: 'Previous',
                subtitle: '${previous.gameTitle}\n${previous.time.format(context)}',
                image: _getActivityImage(previous.gameRoute),
                borderColor: Colors.grey.shade400,
              )
            : _buildEmptyCard('No Previous\nActivity Today', Icons.history),

        // Current Activity
        current != null
            ? _buildActivityCard(
                title: 'Current',
                subtitle: '${current.gameTitle}\n${current.time.format(context)}',
                image: _getActivityImage(current.gameRoute),
                borderColor: Colors.green,
              )
            : _buildEmptyCard('No Current\nActivity Today', Icons.event_available),

        // Next Activity
        next != null
            ? _buildActivityCard(
                title: 'Next',
                subtitle: '${next.gameTitle}\n${next.time.format(context)}',
                image: _getActivityImage(next.gameRoute),
                borderColor: Colors.blue,
              )
            : _buildEmptyCard('No Next\nActivity Today', Icons.event_note),

        // Refresh button
        IconButton(
          onPressed: _loadTodayEvents,
          icon: Icon(
            Icons.refresh,
            size: 16,
            color: Colors.grey.shade600,
          ),
          tooltip: 'Refresh Schedule',
        ),
      ],
    );
  }
}