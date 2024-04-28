import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

class PostDeleteEditTitleBox extends StatelessWidget {
  const PostDeleteEditTitleBox(
      {super.key, required this.title, required this.post});

  final String title;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      decoration: const BoxDecoration(
          color: Color(0xFF469AB8),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
                onPressed: () {
                  _showAlertDialog(context);
                },
                child: const Text("Delete",
                    style: TextStyle(fontSize: 24, color: Colors.red))),
            TextButton(
                onPressed: () {},
                child: const Text("Edit",
                    style: TextStyle(fontSize: 24, color: Colors.white))),
          ])
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
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
                    //Needs to be changed to do the actual deleting of the post.
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
      print("Error deleting post: $error");
    }
  }
}
