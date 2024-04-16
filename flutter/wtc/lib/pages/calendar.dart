import 'package:flutter/material.dart';
import 'package:wtc/widgets/event_widgets/event_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return const Card(
      shadowColor: Colors.transparent,
      margin: EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: Center(
          child: EventCalendar(),
        ),
      ),
    );
  }
}
