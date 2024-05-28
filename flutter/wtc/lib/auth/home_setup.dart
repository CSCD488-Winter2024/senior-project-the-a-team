import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtc/app.dart';
import 'package:wtc/auth/welcome_page.dart';

class HomeSetupPage extends StatelessWidget {
  const HomeSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user!.uid).get(), 
      builder: 
      (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return IntroPage(uid: user.uid);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return const App();
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}