import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';

class SavePost extends StatefulWidget {
  final Guid postId;
  final String? currentUserId;

  const SavePost(
      {super.key, required this.postId, required this.currentUserId});

  @override
  // ignore: library_private_types_in_public_api
  _SavePostState createState() => _SavePostState();
}

class _SavePostState extends State<SavePost> {
  bool isSaved = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    checkIfSaved(widget.postId.toString(), widget.currentUserId ?? '');
  }

  Future<void> changeSavedPosts() async {
    if (isSaved) {
      try {
        await _firestore
            .collection('users')
            .doc(widget.currentUserId.toString())
            .update({
          'saved_posts': FieldValue.arrayUnion([widget.postId.toString()])
        });
      } catch (e) {
        print('Error updating saved posts: $e');
      }
    } else {
      try {
        await _firestore
            .collection('users')
            .doc(widget.currentUserId.toString())
            .update({
          'saved_posts': FieldValue.arrayRemove([widget.postId.toString()])
        });
      } catch (e) {
        print('Error updating saved posts: $e');
      }
    }
    setState(() {
      isSaved = !isSaved;
    });
  }

  Future<void> checkIfSaved(String postId, String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('_posts').doc(postId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('saved_posts') && data['saved_posts'] is List) {
          List<dynamic> savedPostsList = data['saved_posts'];

          if (savedPostsList.contains(postId)) {
            setState(() {
              isSaved = true;
              print(isSaved.toString());
            });
            return;
          }
        }
      }
    } catch (e) {
      print('Error checking user attendance: $e');
    }
    setState(() {
      isSaved = false;
      print(isSaved.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isSaved ? Icon(Icons.bookmark_border) : Icon(Icons.bookmark),
      onPressed: () {
        setState(() {
          changeSavedPosts();
        });
      },
    );
  }
}
