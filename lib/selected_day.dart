import 'package:calendar/event/event_service.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";

class SelectedDay extends StatefulWidget {
  final DateTime selectedDay;
  const SelectedDay({super.key, required this.selectedDay});

  @override
  State<SelectedDay> createState() => _SelectedDayState();
}

class _SelectedDayState extends State<SelectedDay> {
  final TextEditingController eventController = TextEditingController();
  late List<String> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void showAddEvent() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Event'),
            content: TextField(
              controller: eventController,
              decoration: const InputDecoration(hintText: 'Enter event'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  eventController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  EventService().addEvent(
                      event: eventController.text,
                      dateTime: widget.selectedDay);
                  eventController.clear();
                  Navigator.of(context).pop();
                  _loadEvents();
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        });
  }

  Future<void> _loadEvents() async {
    List<String> loadedEvents =
        await EventService().getEventFromDate(dateTime: widget.selectedDay);
    setState(() {
      events = loadedEvents;
    });
  }

  void deleteEvent({required String event}) {
    EventService().deleteEvent(dateTime: widget.selectedDay, event: event);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d MMMM yyyy').format(widget.selectedDay);
    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
      ),
      body: Column(
        children: [
          const Text("Events"),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(events[index]),
                    trailing: IconButton(
                        onPressed: () {
                          deleteEvent(event: events[index]);
                          _loadEvents();
                        },
                        icon: const Icon(Icons.delete_outline)),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddEvent();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
