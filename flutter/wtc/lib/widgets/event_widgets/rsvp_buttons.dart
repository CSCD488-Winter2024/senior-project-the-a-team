import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wtc/widgets/save_post.dart';

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
        // do nothing
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
        // do nothing
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
        // do nothing
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
        // do nothing
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
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('_posts').doc(postID).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('attending') && data['attending'] is List) {
          List<dynamic> attendingList = data['attending'];

          if (attendingList.contains(uid)) {
            if (mounted) {
              setState(() {
                isAttending = true;
              });
            }
            return;
          }
        }
      }
    } catch (e) {
      // do nothing
    }
    if (mounted) {
      setState(() {
        isAttending = false;
      });
    }
  }

  Future<void> checkIfMaybeAttending(String postID, String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('_posts').doc(postID).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('maybe') && data['maybe'] is List) {
          List<dynamic> maybeList = data['maybe'];

          if (maybeList.contains(uid)) {
            if (mounted) {
              // Check if the widget is still in the tree
              setState(() {
                isMaybeAttending = true;
              });
            }
            return;
          }
        }
      }
    } catch (e) {
      // do nothing
    }
    if (mounted) {
      // Check again before setting the state
      setState(() {
        isMaybeAttending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          _firestore.collection('_posts').doc(widget.postID.toString()).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No Data'));
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                changeIsAttending();
              },
              label: const Text("Attend"),
              icon: isAttending
                  ? const Icon(color: Colors.green, Icons.check_box)
                  : const Icon(
                      color: Colors.green, Icons.check_box_outlined),
            ),
            TextButton.icon(
              onPressed: () {
                changeIsMaybeAttending();
              },
              label: const Text("Interested"),
              icon: isMaybeAttending
                  ? const Icon(
                      color: Color.fromARGB(255, 160, 146, 21),
                      Icons.star_rounded)
                  : const Icon(
                      color: Color.fromARGB(255, 160, 146, 21),
                      Icons.star_outline_rounded),
            ),
            const SizedBox(width: 20),
            SavePost(postId: widget.postID, currentUserId: widget.uid)
          ],
        );
      },
    );
  }
}
