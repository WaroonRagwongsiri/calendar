import 'package:calendar/event/event.dart';
import 'package:calendar/event/event_service.dart';
import 'package:calendar/selected_day.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    List<Event> events = await EventService().getEvents();
    setState(() {
      _events = _groupEventsByDate(events);
    });
  }

  Map<DateTime, List<dynamic>> _groupEventsByDate(List<Event> events) {
    Map<DateTime, List<dynamic>> groupedEvents = {};
    for (var event in events) {
      final DateTime date = DateTime(
          event.dateTime.year, event.dateTime.month, event.dateTime.day);
      groupedEvents.update(
        date,
        (existingEvents) => existingEvents..addAll(event.event),
        ifAbsent: () => List.from(event.event),
      );
    }
    return groupedEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(""),),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2007, 3, 15),
            lastDay: DateTime.utc(2030, 3, 15),
            focusedDay: DateTime.now(),
            eventLoader: _eventLoader,
            onDaySelected: (selectedDay, focusedDay) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SelectedDay(selectedDay: selectedDay);
              }));
            },
          )
        ],
      ),
    );
  }

  List<dynamic> _eventLoader(DateTime day) {
    final DateTime date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }
}
