import 'package:flutter/material.dart';
import 'package:wtc/widgets/alerts_list.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPage();
}

class _AlertsPage extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Container(
      color: Colors.white,
      child: SizedBox.expand(
        child: AlertsList(),
      ),
    );
  }
}
