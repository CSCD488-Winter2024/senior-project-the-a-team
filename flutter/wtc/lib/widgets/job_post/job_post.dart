import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    int month = created.month;
    int day = created.day;
    int year = created.year;

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
              // Create a list to hold the children of the Column
              List<Widget> columnChildren = [
                PostTitleBox(title: title),
                PostTagBox(tags: tags),
                PostBodyBox(body: body),
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "posted on: $month-$day-$year",
                      textAlign: TextAlign.left,
                    )),
                JobWageBox(wageType: wageType, wage: wage),
                SavePost(postId: postId, currentUserId: currentUser?.uid.toString()),
                PostDeleteEditBox(post: this)
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
                PostTitleBox(title: title),
                PostTagBox(tags: tags),
                PostBodyBox(body: body),
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "posted on: $month-$day-$year",
                      textAlign: TextAlign.left,
                    )),
                JobWageBox(wageType: wageType, wage: wage),
                SavePost(postId: postId, currentUserId: currentUser?.uid.toString())
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

  void showJobDialog(BuildContext context, List<Widget> columnChildren) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true, content: Column(children: columnChildren));
        });
  }
}
