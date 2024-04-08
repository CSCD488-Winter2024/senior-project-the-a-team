import 'package:flutter/material.dart';
import 'app.dart';

/*
  -- This will be the in point of our app
  -- home is set to our nav bar since this will be housing our page

*/

void main() => runApp(const WTCApp());

class WTCApp extends StatelessWidget {
  const WTCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const App(), //this is imported from app.dart
    );
  }
}
