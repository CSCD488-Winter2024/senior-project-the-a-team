import 'package:flutter/material.dart';
import 'package:wtc/widgets/post_widgets/post_list_review.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPage();
}

class _AboutUsPage extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Cheney Team',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We are a dedicated team of developers working on the Welcome to Cheney app.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Our goal is to provide the residents and visitors of Cheney with a user-friendly and informative app that enhances their experience in the city.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Feel free to explore the app and provide us with your valuable feedback.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
