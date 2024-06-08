import 'dart:convert';

import 'package:calendar/event/event.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class EventService {
  static const String _eventKey = 'events';

  Future<List<Event>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> eventsJson = prefs.getStringList(_eventKey) ?? [];

    List<Event> events = eventsJson.map((eventString) {
      Map<String, dynamic> eventMap = jsonDecode(eventString);
      DateTime dateTime = DateTime.parse(eventMap['dateTime']);
      List<String> eventList = List<String>.from(eventMap['event']);
      List<int> notificationIds = List<int>.from(eventMap['notificationIds']);
      return Event(
        dateTime: dateTime,
        event: eventList,
        notificationIds: notificationIds,
      );
    }).toList();

    return events;
  }

  Future<void> addEvent(
      {required String event, required DateTime dateTime}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> eventsJson = prefs.getStringList(_eventKey) ?? [];

    List<int> notificationIds = [];

    for (int i = 3; i >= 0; i--) {
      notificationIds.add(UniqueKey().hashCode);
    }

    Event newEvent = Event(
      dateTime: dateTime,
      event: [event],
      notificationIds: notificationIds,
    );

    eventsJson.add(jsonEncode({
      'dateTime': newEvent.dateTime.toIso8601String(),
      'event': newEvent.event,
      'notificationIds': newEvent.notificationIds,
    }));

    await prefs.setStringList(_eventKey, eventsJson);
    createNotification(events: event, dateTime: dateTime, notificationIds: notificationIds);
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
      List<int> notificationIds = List<int>.from(eventMap['notificationIds']);
      return Event(
        dateTime: eventDateTime,
        event: eventList,
        notificationIds: notificationIds,
      );
    }).toList();

    for (var e in events) {
      if (e.dateTime == dateTime && e.event.contains(event)) {
        for (int i = 0; i <= 3; i++) {
          AwesomeNotifications().cancel(e.notificationIds[i]);
        }
        e.event.remove(event);
      }
    }

    eventsJson = events
        .map((e) => jsonEncode({
              'dateTime': e.dateTime.toIso8601String(),
              'event': e.event,
              'notificationIds': e.notificationIds,
            }))
        .toList();

    await prefs.setStringList(_eventKey, eventsJson);
  }

  void createNotification(
      {required String events,
      required DateTime dateTime,
      required List<int> notificationIds}) {
    for (int i = 3; i >= 0; i--) {
      DateTime scheduledDate = dateTime.subtract(Duration(days: i));
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationIds[i],
          channelKey: 'calendar_event_channel',
          title: events,
          body: i == 0 ? 'Event is today!' : 'Event is in $i days',
        ),
        schedule: NotificationCalendar.fromDate(date: scheduledDate),
      );
    }
  }
}
