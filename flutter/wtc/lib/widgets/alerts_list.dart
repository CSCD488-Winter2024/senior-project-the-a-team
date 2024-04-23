import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/widgets/event_widgets/event.dart';
import 'package:wtc/widgets/job_post/job_post.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

class AlertsList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AlertsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('_posts')
            .orderBy('timestamp', descending: true)
            .where('type', isEqualTo: 'Alert')
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
    
              var tempTags = document?['tags'] as List<dynamic>;
              List<String> postTags = [];

              for (int i = 0; i < tempTags.length; i++) {
                postTags.add(tempTags[i]);
              }
              return Post(
                  postId: Guid(document?['postID'] as String),
                  header: document?['header'] as String,
                  userEmail: document?['user'] as String,
                  interestCount: document?['interestCount'] as int,
                  created: DateTime(
                      int.parse(dateCreated.split("-")[0]),
                      int.parse(dateCreated.split("-")[1]),
                      int.parse(dateCreated.split("-")[2])),
                  title: document?['title'] as String,
                  tags: postTags,
                  body: document?['body'] as String,
                );
              }
            ,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          );
        });
  }
}
