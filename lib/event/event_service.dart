import 'dart:convert';

import 'package:calendar/event/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventService {
  static const String _eventKey = 'events';

  Future<List<Event>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> eventsJson = prefs.getStringList(_eventKey) ?? [];

    List<Event> events = eventsJson.map((eventString) {
      Map<String, dynamic> eventMap = jsonDecode(eventString);
      DateTime dateTime = DateTime.parse(eventMap['dateTime']);
      List<String> eventList = List<String>.from(eventMap['event']);
      return Event(dateTime: dateTime, event: eventList);
    }).toList();

    return events;
  }

  Future<void> addEvent(
      {required String event, required DateTime dateTime}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> eventsJson = prefs.getStringList(_eventKey) ?? [];

    Event newEvent = Event(dateTime: dateTime, event: [event]);

    eventsJson.add(jsonEncode({
      'dateTime': newEvent.dateTime.toIso8601String(),
      'event': newEvent.event
    }));

    await prefs.setStringList(_eventKey, eventsJson);
  }

  Future<List<String>> getEventFromDate({required DateTime dateTime}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> eventsJson = prefs.getStringList(_eventKey) ?? [];

    List<String> eventsForDate = [];

    for (String eventString in eventsJson) {
      Map<String, dynamic> eventMap = jsonDecode(eventString);
      DateTime eventDateTime = DateTime.parse(eventMap['dateTime']);

      if (eventDateTime.year == dateTime.year &&
          eventDateTime.month == dateTime.month &&
          eventDateTime.day == dateTime.day) {
        List<String> eventList = List<String>.from(eventMap['event']);
        eventsForDate.addAll(eventList);
      }
    }

    return eventsForDate;
  }

  Future<void> deleteEvent(
      {required DateTime dateTime, required String event}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> eventsJson = prefs.getStringList(_eventKey) ?? [];

    List<Event> events = eventsJson.map((eventString) {
      Map<String, dynamic> eventMap = jsonDecode(eventString);
      DateTime eventDateTime = DateTime.parse(eventMap['dateTime']);
      List<String> eventList = List<String>.from(eventMap['event']);
      return Event(dateTime: eventDateTime, event: eventList);
    }).toList();

    events.forEach((e) {
      if (e.dateTime == dateTime && e.event.contains(event)) {
        e.event.remove(event);
      }
    });

    eventsJson = events
        .map((e) => jsonEncode(
            {'dateTime': e.dateTime.toIso8601String(), 'event': e.event}))
        .toList();

    await prefs.setStringList(_eventKey, eventsJson);
  }
}
