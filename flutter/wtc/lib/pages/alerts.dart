 import 'package:flutter/material.dart';
 
class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPage();
}

class _AlertsPage extends State<AlertsPage> {
    @override
    Widget build(BuildContext context) {
       final ThemeData theme = Theme.of(context);
        return Card(
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  'Alerts Page',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          );

    }

}
 
 