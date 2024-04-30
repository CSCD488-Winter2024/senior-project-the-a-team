import 'package:flutter/material.dart';
import 'package:wtc/widgets/post_widgets/post_list.dart';

class AdminReviewPage extends StatefulWidget {
  const AdminReviewPage({super.key});

  @override
  State<AdminReviewPage> createState() => _HomePage();
}

class _HomePage extends State<AdminReviewPage> {
  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: PostList(),
      ),
    );
  }
}
