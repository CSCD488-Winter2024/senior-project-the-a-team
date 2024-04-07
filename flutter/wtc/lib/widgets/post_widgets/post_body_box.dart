import 'package:flutter/material.dart';

class PostBodyBox extends StatelessWidget {
  const PostBodyBox({Key? key, required this.body}) : super(key: key);

  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 600,
        child: Text(
          body,
          textAlign: TextAlign.left,
        ));
  }
}
