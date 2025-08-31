// Schedule Event Model
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleEvent {
  final String id;
  final String gameTitle;
  final TimeOfDay time;
  final String gameRoute;
  final DateTime date;

  ScheduleEvent({
    required this.id,
    required this.gameTitle,
    required this.time,
    required this.gameRoute,
    required this.date,
  });

  // Convert to Firestore document
Map<String, dynamic> toMap() {
  return {
    'gameTitle': gameTitle,
    'timeHour': time.hour,
    'timeMinute': time.minute,
    'gameRoute': gameRoute,
    'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day, 12, 0)), // Store at noon to avoid timezone issues
    'createdAt': Timestamp.now(),
  };
}

  // Helper method to get total minutes since midnight
  int get totalMinutes => time.hour * 60 + time.minute;

  // Create from Firestore document
  factory ScheduleEvent.fromMap(String id, Map<String, dynamic> map) {
    return ScheduleEvent(
      id: id,
      gameTitle: map['gameTitle'] ?? '',
      time: TimeOfDay(
        hour: map['timeHour'] ?? 0,
        minute: map['timeMinute'] ?? 0,
      ),
      gameRoute: map['gameRoute'] ?? '',
      date: map['date'] != null 
          ? (map['date'] as Timestamp).toDate().toLocal()
          : DateTime.now(),
    );
  }
}