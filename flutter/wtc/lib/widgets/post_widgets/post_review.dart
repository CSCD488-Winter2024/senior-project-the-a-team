import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wtc/widgets/user_widgets/user.dart';
import 'package:wtc/widgets/post_widgets/post_review_widget.dart';

// ignore: must_be_immutable
class PostReview extends Post_Review_Widget {
  PostReview(
      {super.key,
      required super.postId,
      required super.title,
      required super.header,
      required super.tags,
      required super.body,
      User? user,
      required super.userEmail,
      required super.interestCount,
      required super.created,
      required super.username,
      required super.pfp});

  void deletePost(BuildContext context) {
    FirebaseFirestore.instance
        .collection('_review_posts')
        .doc(postId.toString())
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post successfully deleted')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error deleting post: $error')));
    });
  }

  void acceptPost(BuildContext context) {
    final docRef = FirebaseFirestore.instance
        .collection('_review_posts')
        .doc(postId.toString());

    docRef.get().then((document) {
      if (document.exists) {
        var data = document.data();
        FirebaseFirestore.instance
            .collection('_posts')
            .doc(postId.toString())
            .set(data!)
            .then((value) => docRef.delete().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Post accepted and moved to active posts')));
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error deleting old post: $error')));
                }))
            .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error adding post to active collection: $error')));
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Post not found')));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error retrieving post: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showPostDialog(context),
      child: Column(
        children: [
          super.build(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => acceptPost(context),
                child: const Text('Accept'),
              ),
              ElevatedButton(
                onPressed: () => deletePost(context),
                child: const Text('Deny'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
