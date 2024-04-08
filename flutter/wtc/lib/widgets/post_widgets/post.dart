import 'package:flutter/material.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box.dart';

class Post extends StatelessWidget {
  Post(
      {Key? key,
      required this.title,
      required this.body,
      required this.tags,
      this.isAlert,
      this.isEvent,
      this.date,
      this.time})
      : super(key: key);

  final String title;
  final String body;
  final List<String> tags;
  final bool? isAlert;
  final bool? isEvent;
  final DateTime? date;
  final TimeOfDay? time;

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
