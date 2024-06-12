import 'package:flutter/material.dart';

class PostBodyBox extends StatelessWidget {
  const PostBodyBox({super.key, required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 600,
        child: Text(
          body,
          textAlign: TextAlign.left,
        ));
  }
}
