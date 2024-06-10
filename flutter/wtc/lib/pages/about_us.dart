import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Welcome to Cheney Team',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18),
              Text(
                  'Welcome to Cheney is a non-profit dedicated to fostering community through reliable information sharing. Our mission is to build a vibrant and thriving community through strategic & intentional communication, bridging connections, and facilitating action.'),
              SizedBox(height: 16),
              Text(
                  'This app was created in partnership with Eastern Washington University. Our team is led by developers Nolan Posey, Matt Matriciano, Tanner Stephenson, Daniel Palmer, and Tim Nelson. Together, we strive to deliver an app that stands out as the primary source of news and events for Cheney residents.'),
              SizedBox(height: 16),
              Text(
                  'With previous attempts overshadowed in noisy social platforms, our app focuses on delivering timely, accurate, and useful content directly to our community.'),
              SizedBox(height: 16),
              Text(
                  'Explore the app and connect with your community like never before. We appreciate your feedback and look forward to enhancing your experience in Cheney.'),
            ],
          ),
        ),
      ),
    );
  }
}
