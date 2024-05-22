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

  @override
  void initState() {
    super.initState();
    checkIfAttending(widget.postID.toString(), widget.uid ?? '');
    checkIfMaybeAttending(widget.postID.toString(), widget.uid ?? '');
    print("is maybe: ${isMaybeAttending.toString()}");
  }

  Future<void> changeIsAttending() async {
    if (isAttending) {
      try {
        await _firestore
            .collection('_posts')
            .doc(widget.postID.toString())
            .update({
          'attending': FieldValue.arrayRemove([widget.uid])
        });
      } catch (e) {
        print('Error updating maybe status: $e');
      }
    } else {
      try {
        await _firestore
            .collection('_posts')
            .doc(widget.postID.toString())
            .update({
          'attending': FieldValue.arrayUnion([widget.uid]),
          'maybe': FieldValue.arrayRemove([widget.uid])
        });
      } catch (e) {
        print('Error updating maybe status: $e');
      }
    }
    setState(() {
      isAttending = !isAttending;
      if (isMaybeAttending) {
        isMaybeAttending = false;
      }
    });
  }

  Future<void> changeIsMaybeAttending() async {
    if (isMaybeAttending) {
      try {
        await _firestore
            .collection('_posts')
            .doc(widget.postID.toString())
            .update({
          'maybe': FieldValue.arrayRemove([widget.uid])
        });
      } catch (e) {
        print('Error updating maybe status: $e');
      }
    } else {
      try {
        await _firestore
            .collection('_posts')
            .doc(widget.postID.toString())
            .update({
          'maybe': FieldValue.arrayUnion([widget.uid]),
          'attending': FieldValue.arrayRemove([widget.uid])
        });
      } catch (e) {
        print('Error updating maybe status: $e');
      }
    }
    setState(() {
      isMaybeAttending = !isMaybeAttending;
      if (isAttending) {
        isAttending = false;
      }
    });
  }

  Future<void> checkIfAttending(String postID, String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('_posts')
          .doc(postID)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('attending') && data['attending'] is List) {
          List<dynamic> attendingList = data['attending'];

          if (attendingList.contains(uid)) {
            setState(() {
              isAttending = true;
            });
            return;
          }
        }
      }
    } catch (e) {
      print('Error checking user attendance: $e');
    }
    setState(() {
      isAttending = false;
    });
  }

  Future<void> checkIfMaybeAttending(String postID, String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('_posts')
          .doc(postID)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('maybe') && data['maybe'] is List) {
          List<dynamic> maybeList = data['maybe'];

          if (maybeList.contains(uid)) {
            setState(() {
              isMaybeAttending = true;
            });
            return;
          }
        }
      }
    } catch (e) {
      print('Error checking user maybe attendance: $e');
    }
    setState(() {
      isMaybeAttending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('_posts').doc(widget.postID.toString()).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No Data'));
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              iconSize: 36,
              onPressed: () {
                changeIsAttending();
              },
              icon: isAttending
                  ? const Icon(color: Colors.green, Icons.check_box)
                  : const Icon(color: Colors.green, Icons.check_box_outlined),
            ),
            IconButton(
              color: const Color.fromARGB(255, 160, 146, 21),
              iconSize: 38,
              onPressed: () {
                changeIsMaybeAttending();
              },
              icon: isMaybeAttending
                  ? const Icon(Icons.star_rounded)
                  : const Icon(Icons.star_outline_rounded),
            ),
          ],
        );
      },
    );
  }
}
