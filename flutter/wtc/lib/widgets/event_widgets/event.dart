// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/User/global_user_info.dart';
import 'package:wtc/widgets/post_widgets/post.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_delete_edit_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box.dart';
import 'package:wtc/widgets/event_widgets/rsvp_buttons.dart';
import 'package:wtc/widgets/going_maybe_count_buttons.dart';

class Event extends Post {
  Event({
    super.key,
    required super.title,
    required super.body,
    required super.tags,
    required super.header,
    required super.interestCount,
    required super.created,
    required super.postId,
    required super.userEmail,
    required this.date,
    required this.time,
    required this.location,
    required this.attendingCount,
    required this.maybeCount,
    required super.isMyPost,
  });

  final DateTime date;
  final TimeOfDay time;
  final String location;
  int attendingCount;
  int maybeCount;

  @override
  Widget build(BuildContext context) {
    String currentUserTier = GlobalUserInfo.getData('tier');
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUserTier == "Admin" ||
        currentUserTier == "Alerter" && currentUser?.email == userEmail ||
        currentUserTier == "Poster" && currentUser?.email == userEmail ||
        isMyPost) {
      return InkWell(
        onTap: () {
          showEventDialog(context, postId);
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
            PostBodyBox(body: header),
            RSVPButtons(postID: postId, uid: currentUser?.uid.toString()),
            PostDeleteEditBox(post: this),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          showEventDialog(context, postId);
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
            PostBodyBox(body: header),
            RSVPButtons(postID: postId, uid: currentUser?.uid.toString()),
          ],
        ),
      );
    }
  }

  void showEventDialog(BuildContext context, Guid postID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: PostTitleBox(title: title),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PostTagBox(tags: tags),
                PostBodyBox(body: "$body\n"),
                SizedBox(
                    width: 600,
                    child: Text(
                      "When: ${date.toString().split(" ")[0]} ${time.toString().split("(")[1].split(")")[0]}",
                      textAlign: TextAlign.left,
                    )),
                SizedBox(
                    width: 600,
                    child: Text(
                      "Where: $location\n",
                      textAlign: TextAlign.left,
                    )),
                GoingMaybeCountButtons(postID: postID)
              ],
            ),
          );
        });
  }
}
