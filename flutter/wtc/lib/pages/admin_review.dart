import 'package:flutter/material.dart';
import 'package:wtc/widgets/post_widgets/post_list_review.dart';

class AdminReviewPage extends StatefulWidget {
  const AdminReviewPage({super.key});

  @override
  State<AdminReviewPage> createState() => _AdminReviewPage();
}

class _AdminReviewPage extends State<AdminReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: PostListReview(),
      ),
    );
  }
}
