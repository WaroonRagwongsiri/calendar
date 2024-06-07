class Event {
  final DateTime dateTime;
  final List<String> event;

  Event({required this.dateTime, required this.event});

  Map<DateTime, dynamic> toMap() {
    return {dateTime: event};
  }
}
