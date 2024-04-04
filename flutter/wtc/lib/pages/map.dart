 import 'package:flutter/material.dart';
 
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
    @override
    Widget build(BuildContext context) {
       final ThemeData theme = Theme.of(context);
        return Card(
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  'Map Page',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          );

    }

}
 
 