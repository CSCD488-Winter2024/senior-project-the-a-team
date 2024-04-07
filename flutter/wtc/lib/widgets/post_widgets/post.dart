import 'package:flutter/material.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box.dart';

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
        PostTitleBox(title: title),
        PostTagBox(tags: tags),
        PostBodyBox(body: body)
      ],
    );
  }
}
