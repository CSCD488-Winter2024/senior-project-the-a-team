import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/User/user.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/post_widgets/post_title_box.dart';
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
          user: user,
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Post successfully deleted')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error deleting post: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showPostDialog(context),
      child: Column(
        children: [
          super.build(context), // This uses the original Post's build method
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => print("Post Accepted"),
                child: Text('Accept'),
              ),
              ElevatedButton(
                onPressed: () => deletePost(context),
                child: Text('Deny'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
