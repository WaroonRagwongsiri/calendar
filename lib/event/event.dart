class Event {
  final DateTime dateTime;
  final List<String> event;

  Event({required this.dateTime, required this.event});

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'events': event,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      dateTime: DateTime.parse(map['dateTime']),
      event: List<String>.from(map['events']),
    );
  }
}
