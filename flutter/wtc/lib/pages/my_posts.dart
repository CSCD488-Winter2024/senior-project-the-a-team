import 'package:flutter/material.dart';
import 'package:wtc/widgets/my_posts_list.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyPostsPageState createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  @override
  Widget build(BuildContext context) {
    return const Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(child: MyPostsList()));
  }
}
