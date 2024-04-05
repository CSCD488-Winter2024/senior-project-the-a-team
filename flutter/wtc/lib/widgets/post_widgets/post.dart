import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post(
      {Key? key,
      required this.title,
      required this.body,
      required this.tags,
      required this.isAlert,
      required this.isEvent})
      : super(key: key);

  final String title;
  final String body;
  final List<String> tags;
  final bool isAlert;
  final bool isEvent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
        ),
        Text('$tags'),
        Text(body)
      ],
    );
  }
}
