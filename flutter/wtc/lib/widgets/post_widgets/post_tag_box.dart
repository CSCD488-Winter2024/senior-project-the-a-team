import 'package:flutter/material.dart';

class PostTagBox extends StatelessWidget {
  const PostTagBox({Key? key, required this.tags}) : super(key: key);

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    String tagList = "";
    for (int i = 0; i < tags.length; i++) {
      tagList += "#";
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
          style: TextStyle(color: Color(0xFF469AB8))
        ));
  }
}
