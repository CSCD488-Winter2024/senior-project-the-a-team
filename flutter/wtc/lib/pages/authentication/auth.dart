import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtc/pages/authentication/home_setup.dart';
import 'package:wtc/pages/authentication/login.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeSetupPage();
        } else {
          return const LoginPage();
        }
      },
    ));
  }
}
