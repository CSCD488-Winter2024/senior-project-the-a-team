 import 'package:flutter/material.dart';
 
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
    @override
    Widget build(BuildContext context) {
       final ThemeData theme = Theme.of(context);
        return Card(
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  'Home Page',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          );

    }

}
 
 