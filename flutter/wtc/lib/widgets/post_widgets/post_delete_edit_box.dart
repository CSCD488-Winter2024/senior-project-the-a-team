import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wtc/pages/edit_event.dart';
import 'package:wtc/pages/edit_job.dart';
import 'package:wtc/pages/edit_post.dart';
import 'package:wtc/widgets/event_widgets/event.dart';
import 'package:wtc/widgets/job_post/job_post.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

class PostDeleteEditBox extends StatelessWidget {
  const PostDeleteEditBox({super.key, required this.post, required this.isViewer});

  final Post post;
  final bool isViewer;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextButton(
          onPressed: () {
            _showDeleteDialog(context);
          },
          child: const Text("Delete",
              style: TextStyle(fontSize: 24, color: Colors.red))),
      const SizedBox(width: 60),
      if (!isViewer)
        TextButton(
          onPressed: () {
            if (post is Event) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditPostEventPage(post: post as Event)),
              );
            } else if (post is JobPost) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditPostJobPage(post: post as JobPost)),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditPostPage(post: post)),
              );
            }
          },
          child: const Text("Edit",
              style: TextStyle(fontSize: 24, color: Color(0xFF469AB8)))),
    ]);
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text(
                "Delete Post",
                textAlign: TextAlign.center,
              ),
              content: const Text("Are you sure you want to delete this post?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close", style: TextStyle(fontSize: 24)),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _deletePost(post.postId.toString());
                  },
                  child: const Text("Delete",
                      style: TextStyle(fontSize: 24, color: Colors.red)),
                )
              ]);
        });
  }

  Future<void> _deletePost(String docId) async {
    try {
      await FirebaseFirestore.instance.collection("_posts").doc(docId).delete();
    } catch (error) {
      // do nothing
    }
  }
}
