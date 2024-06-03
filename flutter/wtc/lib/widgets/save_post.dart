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

  Future<void> addArrayFieldToCollection(
      String collectionName, String fieldName, List<dynamic> fieldValue) async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(collectionName);

    final QuerySnapshot snapshot = await collectionRef.get();
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      DocumentReference docRef = collectionRef.doc(doc.id);
      batch.update(docRef, {fieldName: fieldValue});
    }

    await batch.commit();
    print(
        "Added array field '$fieldName' with value '$fieldValue' to all documents in the '$collectionName' collection.");
  }

  Future<void> changeSavedPosts() async {
    if (!isSaved) {
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
          await _firestore.collection('users').doc(userId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        bool currentlySaved = data['saved_posts']?.contains(postId) ?? false;

        if (mounted) {
          setState(() {
            isSaved = currentlySaved;
            print(isSaved.toString());
          });
        }
      }
    } catch (e) {
      print('Error checking user saved posts: $e');
      if (mounted) {
        setState(() {
          isSaved = false;
          print(isSaved.toString());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: const Text("Save"),
      icon: isSaved
          ? const Icon(color: Colors.blueGrey, Icons.bookmark)
          : const Icon(color: Colors.blueGrey, Icons.bookmark_border_outlined),
      onPressed: () {
        setState(() {
          changeSavedPosts();
        });
      },
    );
  }
}
