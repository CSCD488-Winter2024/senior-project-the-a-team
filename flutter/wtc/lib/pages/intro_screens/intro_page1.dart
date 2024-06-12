import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffBD9F4C),
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(height: 150),
          Lottie.asset("images/crops.json", height: 300),
          const Text(
            "Welcome to WTC",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Let's get you started.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      )
    );
  }
}