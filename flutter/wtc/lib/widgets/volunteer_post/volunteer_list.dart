import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/widgets/job_post/job_post.dart';

// ignore: must_be_immutable
class VolunteerPostList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  VolunteerPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('_posts')
            .where('type', isEqualTo: 'Volunteer')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              var document = snapshot.data?.docs[index];

              String dateCreated = document?['createdAt'] as String;

              return JobPost(
                title: document?['title'] as String,
                body: document?['body'] as String,
                tags: const ["Volunteer"],
                header: document?['header'] as String,
                userEmail: document?['user'] as String,
                interestCount: document?['interestCount'] as int,
                created: DateTime(
                    int.parse(dateCreated.split("-")[0]),
                    int.parse(dateCreated.split("-")[1]),
                    int.parse(dateCreated.split("-")[2])),
                postId: Guid(document?['postID'] as String),
                volunteer: true,
                isMyPost: false,
                pfp: document?['pfp'] as String,
                username: document?['username'] as String,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          );
        });
  }
}
