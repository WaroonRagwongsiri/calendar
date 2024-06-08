class Event {
  DateTime dateTime;
  List<String> event;
  List<int> notificationIds;

  Event({required this.dateTime, required this.event, required this.notificationIds});

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'event': event,
      'notificationIds': notificationIds,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      dateTime: DateTime.parse(json['dateTime']),
      event: List<String>.from(json['event']),
      notificationIds: List<int>.from(json['notificationIds']),
    );
  }
}
