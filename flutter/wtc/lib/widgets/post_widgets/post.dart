import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/User/User.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box.dart';

class Post extends StatelessWidget {
  const Post(
      {Key? key,
      required this.title,
      required this.body,
      required this.tags,
      required this.postId,
      required this.header,
      required this.user,
      required this.interestCount,
      required this.created})
      : super(key: key);

  final Guid postId;
  final String title;
  final String header;
  final List<String> tags;
  final String body;
  final User user;
  final int interestCount;
  final DateTime created;

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
