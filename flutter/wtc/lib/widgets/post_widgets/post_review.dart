import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/user/user.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

class PostReview extends Post {
  PostReview({
    Key? key,
    required Guid postId,
    required String title,
    required String header,
    required List<String> tags,
    required String body,
    User? user,
    required String userEmail,
    required int interestCount,
    required DateTime created,
  }) : super(
          key: key,
          postId: postId,
          title: title,
          header: header,
          tags: tags,
          body: body,
          userEmail: userEmail,
          interestCount: interestCount,
          created: created,
        );

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
