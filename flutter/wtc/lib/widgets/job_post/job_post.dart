import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtc/User/global_user_info.dart';
import 'package:wtc/widgets/post_widgets/post_delete_edit_box.dart';
import 'package:wtc/widgets/save_post.dart';
import '../post_widgets/post.dart';
import '../post_widgets/post_body_box.dart';
import '../post_widgets/post_tag_box.dart';
import '../post_widgets/post_title_box.dart';
import 'job_wage_box.dart';

// ignore: must_be_immutable
class JobPost extends Post {
  double wage;
  bool volunteer;
  String wageType;

  JobPost({
    super.key,
    required super.title,
    required super.body,
    required super.tags,
    required super.header,
    required super.interestCount,
    required super.created,
    required super.postId,
    this.volunteer = false,
    this.wageType = "",
    this.wage = 0.0,
    required super.userEmail,
    required super.isMyPost,
    required super.username,
    required super.pfp
  });

  @override
  Widget build(BuildContext context) {
    int month = created.month;
    int day = created.day;
    int year = created.year;

    String currentUserTier = GlobalUserInfo.getData('tier');
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUserTier == "Admin" ||
        currentUser?.email == userEmail ||
        isMyPost) {
      // Create a list to hold the children of the Column
      List<Widget> columnChildren = [
        PostTitleBox(
              title: title,
              username: username,
              created: created,
              pfp: pfp,
            ),
        Row(
           mainAxisAlignment: MainAxisAlignment.end,
           children: [
              SavePost(
                  postId: postId,
                  currentUserId: currentUser?.uid.toString())
        ]),
        JobWageBox(wageType: wageType, wage: wage),
        PostBodyBox(body: body),
        PostTagBox(tags: tags),
        if(currentUserTier != 'Viewer')
        PostDeleteEditBox(post: this, isViewer: false,)
        else
        PostDeleteEditBox(post: this, isViewer: true)
      ];

      // Return the Column with all children
      return InkWell(
        onTap: () {
          showJobDialog(context, columnChildren);
        },
        child: Column(
          children: columnChildren,
        ),
      );
    } else {
      // Create a list to hold the children of the Column
      List<Widget> columnChildren = [
        PostTitleBox(
              title: title,
              username: username,
              created: created,
              pfp: pfp,
            ),
        Row(
           mainAxisAlignment: MainAxisAlignment.end,
           children: [
              SavePost(
                  postId: postId,
                  currentUserId: currentUser?.uid.toString())
        ]),
        JobWageBox(wageType: wageType, wage: wage),
        PostBodyBox(body: body),
        PostTagBox(tags: tags),
      ];

      // Return the Column with all children
      return InkWell(
        onTap: () {
          showJobDialog(context, columnChildren);
        },
        child: Column(
          children: columnChildren,
        ),
      );
    }
  }

  void showJobDialog(BuildContext context, List<Widget> columnChildren) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true, content: Column(children: columnChildren));
        });
  }
}
