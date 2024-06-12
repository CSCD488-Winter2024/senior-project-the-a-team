import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/widgets/user_widgets/global_user_info.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_delete_edit_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box_expanded.dart';
import 'package:wtc/widgets/post_widgets/save_post.dart';

// ignore: must_be_immutable
class Post extends StatelessWidget {
  Post(
      {super.key,
      required this.title,
      required this.body,
      required this.tags,
      required this.header,
      required this.userEmail,
      required this.interestCount,
      required this.created,
      required this.postId,
      required this.isMyPost,
      required this.username,
      required this.pfp});

  Guid postId;
  final String title;
  final String header;
  final List<String> tags;
  final String body;
  final String userEmail;
  final int interestCount;
  final DateTime created;
  final bool isMyPost;
  final String username;
  final String pfp;

  @override
  Widget build(BuildContext context) {
    String currentUserTier = GlobalUserInfo.getData('tier');
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUserTier == "Admin" ||
        (currentUserTier == "Poster" && currentUser?.email == userEmail) ||
        (isMyPost && currentUserTier != "Viewer")) {
      return InkWell(
        onTap: () {
          showPostDialog(context);
        },
        child: Column(
          children: [
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
                  currentUserId: currentUser?.uid.toString(),
                ),
              ],
            ),
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
          showPostDialog(context);
        },
        child: Column(
          children: [
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
                  currentUserId: currentUser?.uid.toString(),
                ),
              ],
            ),
            PostBodyBox(body: header),
            PostTagBox(tags: tags),
          ],
        ),
      );
    }
  }

  void showPostDialog(BuildContext context) {
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
                  children: [PostBodyBox(body: body), PostTagBox(tags: tags)]));
        });
  }

  Future<String> fetchUserTier() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userTier = "";
    if (currentUser != null && currentUser.email != null) {
      DocumentSnapshot<Map<String, dynamic>> userDetails =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser.uid)
              .get();

      userTier = userDetails.data()?['tier'] ??
          'viewer'; // Store user tier or default to viewer
    }
    return userTier;
  }
}

extension UtilExtensions on String {
  List<String> multiSplit(Iterable<String> delimeters) => delimeters.isEmpty
      ? [this]
      : split(RegExp(delimeters.map(RegExp.escape).join('|')));
}
