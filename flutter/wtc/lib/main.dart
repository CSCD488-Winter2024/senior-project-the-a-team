import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wtc/auth/auth.dart';
import 'package:wtc/firebase_options.dart';
//import 'app.dart';

/*
  -- This will be the in point of our app
  -- home is set to our nav bar since this will be housing our page

*/

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const WTCApp());
}

class WTCApp extends StatelessWidget {
  const WTCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const AuthPage() //App entry point
    );
  }
}

