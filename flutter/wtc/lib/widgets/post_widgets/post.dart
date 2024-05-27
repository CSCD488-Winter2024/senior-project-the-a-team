// ignore_for_file: must_be_immutable, unnecessary_this

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
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
      required this.postId})
      : super(key: key);

  Guid postId;
  final String title;
  final String header;
  final List<String> tags;
  final String body;
  final String userEmail;
  final int interestCount;
  final DateTime created;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchUserTier(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            String currentUserTier = snapshot.data!;
            User? currentUser = FirebaseAuth.instance.currentUser;
            if (currentUserTier == "Admin" ||
                (currentUserTier == "Poster" &&
                    currentUser?.email == userEmail)) {
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

                    PostBodyBox(body: header),
                    SavePost(postId: postId, currentUserId: currentUser?.uid.toString()),
                    PostDeleteEditBox(post: this)
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
                    PostTitleBox(title: title),
                    PostTagBox(tags: tags),
                    SizedBox(
                        width: 600,
                        child: Text(
                          "Posted on: ${created.toString().split(" ")[0]}\n",
                          textAlign: TextAlign.left,
                        )),
                    PostBodyBox(body: header)
                    SavePost(postId: postId, currentUserId: currentUser?.uid.toString())
                  ],
                ),
              );
            }
          } else {
            // This handles the case where snapshot has data but it's null or some unexpected condition
            return const Text('Unexpected error. Please try again later.');
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading spinner while waiting for data
        } else {
          // This handles any other unanticipated state of the snapshot
          return const Text('Something went wrong. Please try again.');
        }
      },
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

  Future<String> fetchUserTier() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userTier = "";
    if (currentUser != null && currentUser.email != null) {
      DocumentSnapshot<Map<String, dynamic>> userDetails =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser.email)
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
