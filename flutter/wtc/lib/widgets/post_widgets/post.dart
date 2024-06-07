import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/User/global_user_info.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_delete_edit_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box.dart';
import 'package:wtc/widgets/save_post.dart';

class Post extends StatelessWidget {
  Post(
      {Key? key,
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
      required this.pfp})
      : super(key: key);

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
            PostDeleteEditBox(post: this),
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
              title: PostTitleBox(
                title: title,
                username: username,
                created: created,
                pfp: pfp,
              ),
              content: Column(
                  children: [PostTagBox(tags: tags), PostBodyBox(body: body)]));
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
      : this.split(RegExp(delimeters.map(RegExp.escape).join('|')));
}
