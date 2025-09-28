// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../schedule/schedule_event.dart';

// Schedule Calendar Page
class ScheduleCalendarPage extends StatefulWidget {
  const ScheduleCalendarPage({super.key});

  @override
  State<ScheduleCalendarPage> createState() => _ScheduleCalendarPageState();
}

class _ScheduleCalendarPageState extends State<ScheduleCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<ScheduleEvent>> _events = {};
  bool _isLoading = true;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Available games list
  final List<Map<String, String>> _availableGames = [
    {'title': 'A B C', 'route': 'abc'},
    {'title': 'Numbers', 'route': 'numbers'},
    {'title': 'Colors', 'route': 'colors'},
    {'title': 'Shapes', 'route': 'shapes'},
    {'title': 'Objects', 'route': 'objects'},
    {'title': 'Food', 'route': 'food'},
    {'title': 'Places', 'route': 'places'},
    {'title': 'Feelings', 'route': 'feelings'},
    {'title': 'Action Verbs', 'route': 'actions'},
    {'title': 'Sight Words', 'route': 'sight_words'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadEvents();
  }

  // Get current user's schedule collection reference
  CollectionReference get _userScheduleCollection {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('schedule_events');
  }

  // Load events from Firestore
  Future<void> _loadEvents() async {
    try {
      setState(() => _isLoading = true);
      
      final user = _auth.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final querySnapshot = await _userScheduleCollection.get();
      
      final Map<DateTime, List<ScheduleEvent>> loadedEvents = {};
      
      for (var doc in querySnapshot.docs) {
        final event = ScheduleEvent.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        final dateKey = DateTime(event.date.year, event.date.month, event.date.day);
        
        if (loadedEvents[dateKey] != null) {
          loadedEvents[dateKey]!.add(event);
        } else {
          loadedEvents[dateKey] = [event];
        }
      }

      setState(() {
        _events = loadedEvents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load events: $e');
    }
  }

  // Add event to Firestore
  Future<void> _addEventToFirestore(DateTime date, ScheduleEvent event) async {
    try {
      await _userScheduleCollection.add(event.toMap());
      _showSuccessSnackBar('Activity scheduled successfully!');
    } catch (e) {
      _showErrorSnackBar('Failed to schedule activity: $e');
    }
  }

  // Delete event from Firestore
  Future<void> _deleteEventFromFirestore(String eventId) async {
    try {
      await _userScheduleCollection.doc(eventId).delete();
      _showSuccessSnackBar('Activity removed successfully!');
    } catch (e) {
      _showErrorSnackBar('Failed to remove activity: $e');
    }
  }

  List<ScheduleEvent> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _addEvent(DateTime date, ScheduleEvent event) {
    final dateKey = DateTime(date.year, date.month, date.day);
    if (_events[dateKey] != null) {
      _events[dateKey]!.add(event);
    } else {
      _events[dateKey] = [event];
    }
    setState(() {});
  }

  void _removeEvent(DateTime date, int index) {
    final dateKey = DateTime(date.year, date.month, date.day);
    if (_events[dateKey] != null) {
      _events[dateKey]!.removeAt(index);
      if (_events[dateKey]!.isEmpty) {
        _events.remove(dateKey);
      }
    }
    setState(() {});
  }

  void _showAddEventDialog(DateTime selectedDate) {
    TimeOfDay selectedTime = TimeOfDay.now();
    String? selectedGame;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Schedule Activity',
            style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date display
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Date: ${selectedDate.month}/${selectedDate.day}/${selectedDate.year}',
                  style: GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              
              const SizedBox(height: 16),

              // Time picker
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  'Time: ${selectedTime.format(context)}',
                  style: GoogleFonts.ubuntu(),
                ),
                onTap: isSubmitting ? null : () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    setDialogState(() {
                      selectedTime = picked;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // Game selection dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Game',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabled: !isSubmitting,
                ),
                initialValue: selectedGame,
                items: _availableGames.map((game) {
                  return DropdownMenuItem<String>(
                    value: game['route'],
                    child: Text(
                      game['title']!,
                      style: GoogleFonts.ubuntu(),
                    ),
                  );
                }).toList(),
                onChanged: isSubmitting ? null : (value) {
                  setDialogState(() {
                    selectedGame = value;
                  });
                },
              ),

              if (isSubmitting) ...[
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text('Scheduling...'),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.ubuntu(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: (selectedGame != null && !isSubmitting)
                  ? () async {
                      setDialogState(() => isSubmitting = true);
                      
                      final gameTitle = _availableGames
                          .firstWhere((game) => game['route'] == selectedGame)['title']!;
                      
                      final newEvent = ScheduleEvent(
                        id: '', // Will be set by Firestore
                        gameTitle: gameTitle,
                        time: selectedTime,
                        gameRoute: selectedGame!,
                        date: selectedDate,
                      );

                      try {
                        await _addEventToFirestore(selectedDate, newEvent);
                        
                        // Add to local state with temporary ID
                        final eventWithId = ScheduleEvent(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          gameTitle: gameTitle,
                          time: selectedTime,
                          gameRoute: selectedGame!,
                          date: selectedDate,
                        );
                        
                        _addEvent(selectedDate, eventWithId);
                        Navigator.pop(context);
                        
                        // Reload events to get proper Firestore IDs
                        _loadEvents();
                      } catch (e) {
                        setDialogState(() => isSubmitting = false);
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Add',
                style: GoogleFonts.ubuntu(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Schedule Activities',
            style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule Activities',
          style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEvents,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar
          TableCalendar<ScheduleEvent>(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2034, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade300,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.ubuntu(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),

          const SizedBox(height: 16),

          // Add Event Button
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () => _showAddEventDialog(_selectedDay!),
                icon: const Icon(Icons.add),
                label: Text(
                  'Add Activity',
                  style: GoogleFonts.ubuntu(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Events List
          Expanded(
            child: _selectedDay != null
                ? _buildEventsList()
                : Center(
                    child: Text(
                      'Select a date to view scheduled activities',
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Get activity image based on game route
  AssetImage _getActivityImage(String gameRoute) {
    switch (gameRoute) {
      case 'abc':
        return const AssetImage('assets/homepage_images/abc.webp');
      case 'numbers':
        return const AssetImage('assets/homepage_images/numbers.webp');
      case 'colors':
        return const AssetImage('assets/homepage_images/colors.webp');
      case 'shapes':
        return const AssetImage('assets/homepage_images/shapes.webp');
      case 'objects':
        return const AssetImage('assets/homepage_images/objects.webp');
      case 'food':
        return const AssetImage('assets/homepage_images/food.webp');
      case 'places':
        return const AssetImage('assets/homepage_images/places.webp');
      case 'feelings':
        return const AssetImage('assets/homepage_images/feelings.webp');
      case 'actions':
        return const AssetImage('assets/homepage_images/action.webp');
      case 'sight_words':
        return const AssetImage('assets/homepage_images/sight.webp');
      default:
        return const AssetImage('assets/homepage_images/abc.webp');
    }
  }

  Widget _buildEventsList() {
    final events = _getEventsForDay(_selectedDay!);
    
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No activities scheduled for this day',
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // Sort events by time
    events.sort((a, b) {
      final aMinutes = a.time.hour * 60 + a.time.minute;
      final bMinutes = b.time.hour * 60 + b.time.minute;
      return aMinutes.compareTo(bMinutes);
    });

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: _getActivityImage(event.gameRoute),
            ),
            title: Text(
              event.gameTitle,
              style: GoogleFonts.ubuntu(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Scheduled for ${event.time.format(context)}',
              style: GoogleFonts.ubuntu(color: Colors.grey.shade600),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(event, index),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(ScheduleEvent event, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Remove Activity',
          style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove "${event.gameTitle}" from your schedule?',
          style: GoogleFonts.ubuntu(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.ubuntu(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                await _deleteEventFromFirestore(event.id);
                _removeEvent(_selectedDay!, index);
              } catch (e) {
                _showErrorSnackBar('Failed to remove activity: $e');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Remove',
              style: GoogleFonts.ubuntu(),
            ),
          ),
        ],
      ),
    );
  }
}
