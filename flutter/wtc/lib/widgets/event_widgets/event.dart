// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:wtc/widgets/post_widgets/post.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box.dart';

class Event extends Post {
  Event({
    Key? key,
    required super.title,
    required super.body,
    required super.tags,
    required super.header,
    required super.user,
    required super.interestCount,
    required super.created,
    required super.postId,
    required this.date,
    required this.time,
    required this.location,
    required this.attendingCount,
    required this.maybeCount,
  }) : super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final String location;
  int attendingCount;
  int maybeCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostTitleBox(title: title),
        PostTagBox(tags: tags),
        PostBodyBox(body: body),
        SizedBox(
            width: 600,
            child: Text(
              "When: ${date.toString().split(" ")[0]} ${time.toString().split("(")[1].split(")")[0]}",
              textAlign: TextAlign.left,
            )),
        SizedBox(
            width: 600,
            child: Text(
              "Where: $location",
              textAlign: TextAlign.left,
            )),
        SizedBox(
            width: 600,
            child: Text(
              "Attending: $attendingCount         Maybe Going: $maybeCount",
              textAlign: TextAlign.center,
            ))
      ],
    );
  }
}
