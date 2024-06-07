import 'package:calendar/selected_day.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2007, 3, 15),
            lastDay: DateTime.utc(2030, 3, 15),
            focusedDay: DateTime.now(),
            eventLoader: (day) {
              return [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return SelectedDay(selectedDay: selectedDay);
              }));
            },
          )
        ],
      ),
    );
  }
}
