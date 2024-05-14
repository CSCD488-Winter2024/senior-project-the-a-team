import 'package:flutter/material.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade500,
      alignment: Alignment.center,
      child: const Text(
        "Intro Page 3",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}