// ignore_for_file: must_be_immutable, unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/User/user.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box.dart';

class Post extends StatelessWidget {
  Post(
      {Key? key,
      required this.title,
      required this.body,
      required this.tags,
      required this.header,
      required this.user,
      required this.interestCount,
      required this.created,
      required this.postId})
      : super(key: key);

  Guid postId;
  final String title;
  final String header;
  final List<String> tags;
  final String body;
  final User user;
  final int interestCount;
  final DateTime created;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showPostDialog(context);
      },
      child: Column(
        children: [
          PostTitleBox(title: title),
          PostTagBox(tags: tags),
          SizedBox(
              width: 600,
              child: Text(
                "Posted on: ${created.toString().split(" ")[0]}\n",
                textAlign: TextAlign.left,
              )),
          PostBodyBox(body: body.multiSplit([".", "!", "?"])[0])
        ],
      ),
    );
  }

  void showPostDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              title: PostTitleBox(title: title),
              content: Column(
                  children: [PostTagBox(tags: tags), PostBodyBox(body: body)]));
        });
  }
}

extension UtilExtensions on String {
  List<String> multiSplit(Iterable<String> delimeters) => delimeters.isEmpty
      ? [this]
      : this.split(RegExp(delimeters.map(RegExp.escape).join('|')));
}
