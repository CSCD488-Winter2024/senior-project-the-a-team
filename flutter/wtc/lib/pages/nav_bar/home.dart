import 'package:flutter/material.dart';
import 'package:wtc/widgets/lists/post_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Container(
      color: Colors.white,
      child: const SizedBox.expand(
        child: PostList(),
      ),
    );
  }
}
