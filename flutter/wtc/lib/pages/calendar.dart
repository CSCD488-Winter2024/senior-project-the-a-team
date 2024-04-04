 import 'package:flutter/material.dart';
 
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
    @override
    Widget build(BuildContext context) {
       final ThemeData theme = Theme.of(context);
        return Card(
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  'Calendar Page',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          );

    }

}
 
 