// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtc/widgets/post_widgets/post.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_delete_edit_box.dart';
import 'package:wtc/widgets/post_widgets/post_delete_edit_title_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box.dart';

class Event extends Post {
  Event({
    Key? key,
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
  }) : super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final String location;
  int attendingCount;
  int maybeCount;

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
                  showEventDialog(context);
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
                    PostBodyBox(body: body.multiSplit([".", "!", "?"])[0]),
                    PostDeleteEditBox(post: this)
                  ],
                ),
              );
            } else {
              return InkWell(
                onTap: () {
                  showEventDialog(context);
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
                    PostBodyBox(body: body.multiSplit([".", "!", "?"])[0]),
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

  void showEventDialog(BuildContext context) {
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
                SizedBox(
                    width: 600,
                    child: Text(
                      "Attending: $attendingCount     Maybe Going: $maybeCount",
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
          );
        });
  }
}
