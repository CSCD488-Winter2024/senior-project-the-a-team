import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class RSVPButtons extends StatefulWidget {
  Guid postID;
  String? uid;

  RSVPButtons({super.key, required this.postID, required this.uid});

  @override
  State<StatefulWidget> createState() => _RSVPButtons();
}

class _RSVPButtons extends State<RSVPButtons> {
  bool isAttending = false;
  bool isMaybeAttending = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> changeIsAttending() async {
    setState(() {
      isAttending = !isAttending;
      if (isMaybeAttending) {
        isMaybeAttending = false;
      }
    });
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('_posts')
        .doc(widget.postID.toString())
        .get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      print('Document data before update: $data');
    } else {
      print('Document does not exist.');
      return;
    }

    try {
      await _firestore
          .collection('_posts')
          .doc(widget.postID.toString())
          .update({
        'attending': FieldValue.arrayUnion([widget.uid]),
        'maybe': FieldValue.arrayRemove([widget.uid])
      });
    } catch (e) {
      print('Error updating maybe status:$e');
    }
  }

  Future<void> changeIsMaybeAttending() async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('_posts')
        .doc(widget.postID.toString())
        .get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      print('Document data before update: $data');
    } else {
      print('Document does not exist.');
      return;
    }

    try {
      await _firestore
          .collection('_posts')
          .doc(widget.postID.toString())
          .update({
        'maybe': FieldValue.arrayUnion([widget.uid]),
        'attending': FieldValue.arrayRemove([widget.uid])
      });
    } catch (e) {
      print('Error updating maybe status:$e');
    }
    setState(() {
      isMaybeAttending = !isMaybeAttending;
      if (isAttending) {
        isAttending = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          _firestore.collection('_posts').doc(widget.postID.toString()).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No Data'));
        }

        DocumentSnapshot documentSnapshot = snapshot.data!;

        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              iconSize: 36,
              onPressed: () {
                changeIsAttending();
              },
              icon: isAttending
                  ? const Icon(color: Colors.green, Icons.check_box)
                  : const Icon(color: Colors.green, Icons.check_box_outlined)),
          IconButton(
              color: const Color.fromARGB(255, 160, 146, 21),
              iconSize: 38,
              onPressed: () {
                changeIsMaybeAttending();
              },
              icon: isMaybeAttending
                  ? const Icon(Icons.star_rounded)
                  : const Icon(Icons.star_outline_rounded))
        ]);
      },
    );
  }
}
