import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: 'calendar_event_channel',
          channelName: 'Calendar Event Notification',
          channelDescription: 'Notification channel for calendar events')
    ],
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Calendar(),
      theme: ThemeData.dark(),
    );
  }
}
