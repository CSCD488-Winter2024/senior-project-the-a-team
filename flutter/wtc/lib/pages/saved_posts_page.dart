import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtc/widgets/saved_posts_list.dart';

class SavedPosts extends StatefulWidget {
  const SavedPosts({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SavedPostsState createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    return  SizedBox.expand(
      child: SavedPostsList(uid: currentUser?.uid),
    );
  }
}
