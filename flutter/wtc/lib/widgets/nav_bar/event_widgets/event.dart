// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/widgets/user_widgets/global_user_info.dart';
import 'package:wtc/widgets/post_widgets/post.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_delete_edit_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box_expanded.dart';
import 'package:wtc/widgets/nav_bar/event_widgets/rsvp_buttons.dart';
import 'package:wtc/widgets/nav_bar/event_widgets/going_maybe_count_buttons.dart';

class Event extends Post {
  Event(
      {super.key,
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
      required super.username,
      required super.pfp});

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
        currentUser?.email == userEmail ||
        isMyPost) {
      return InkWell(
        onTap: () {
          showEventDialog(context, postId);
        },
        child: Column(
          children: [
            PostTitleBox(
              title: title,
              username: username,
              created: created,
              pfp: pfp,
            ),
            RSVPButtons(postID: postId, uid: currentUser?.uid.toString()),
            PostBodyBox(body: header),
            PostTagBox(tags: tags),
            if (currentUserTier != 'Viewer')
              PostDeleteEditBox(
                post: this,
                isViewer: false,
              )
            else
              PostDeleteEditBox(
                post: this,
                isViewer: true,
              )
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
            PostTitleBox(
              title: title,
              username: username,
              created: created,
              pfp: pfp,
            ),
            RSVPButtons(postID: postId, uid: currentUser?.uid.toString()),
            PostBodyBox(body: header),
            PostTagBox(tags: tags),
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
            title: PostTitleBoxExpanded(
              title: title,
              username: username,
              created: created,
              pfp: pfp,
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                PostTagBox(tags: tags),
                GoingMaybeCountButtons(postID: postID),
              ],
            ),
          );
        });
  }
}
