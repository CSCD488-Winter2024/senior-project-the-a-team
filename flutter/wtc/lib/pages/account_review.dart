import 'package:flutter/material.dart';

class AccountReviewPage extends StatefulWidget {
  const AccountReviewPage({super.key});

  @override
  State<AccountReviewPage> createState() => _AccountReviewPageState();
}

class _AccountReviewPageState extends State<AccountReviewPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Account Review Page")
          ],
        )
      ),
    );
  }
}