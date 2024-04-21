import 'package:flutter/material.dart';

class PostTagBox extends StatelessWidget {
  const PostTagBox({Key? key, required this.tags}) : super(key: key);

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    String tagList = "Tags: ";
    for (int i = 0; i < tags.length; i++) {
      if (i == (tags.length - 1)) {
        tagList += tags[i];
      } else {
        tagList += ("${tags[i]}, ");
      }
    }
    return Container(
        width: 600,
        child: Text(
          tagList,
          textAlign: TextAlign.left,
        ));
  }
}
