import 'package:flutter/material.dart';

class PostTitleBox extends StatelessWidget {
  const PostTitleBox({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      color: Colors.red,
      child: Text(
        title,
        style: const TextStyle(fontSize: 24),
        textAlign: TextAlign.left,
      ),
    );
  }
}
