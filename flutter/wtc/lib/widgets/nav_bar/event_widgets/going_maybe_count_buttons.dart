import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/pages/nav_bar/event_pages/attending_event_page.dart';

class GoingMaybeCountButtons extends StatefulWidget {
  final Guid postID;

  const GoingMaybeCountButtons({super.key, required this.postID});

  @override
  State<StatefulWidget> createState() => _GoingMaybeCountButtonsState();
}

class _GoingMaybeCountButtonsState extends State<GoingMaybeCountButtons> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int attendingCount = 0;
  int maybeCount = 0;

  @override
  void initState() {
    super.initState();
    getAttendeesCount();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AttendingEventPage(
                            postID: widget.postID,
                            attendanceMap: 'attending',
                            attending: 'Attending',
                          )));
            },
            child: const Text(
              "Attending",
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 80, 145),
                  decoration: TextDecoration.underline),
            ),
          ),
          Text("$attendingCount"),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AttendingEventPage(
                            postID: widget.postID,
                            attendanceMap: 'maybe',
                            attending: 'Interested',
                          )));
            },
            child: const Text(
              "Maybe",
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 80, 145),
                  decoration: TextDecoration.underline),
            ),
          ),
          Text("$maybeCount"),
        ],
      ),
    );
  }

  Future<void> getAttendeesCount() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('_posts')
          .doc(widget.postID.toString())
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('attending') && data['attending'] is List) {
          List<dynamic> attendingList = data['attending'];
          setState(() {
            attendingCount = attendingList.length;
          });
        }

        if (data.containsKey('maybe') && data['maybe'] is List) {
          List<dynamic> maybeList = data['maybe'];
          setState(() {
            maybeCount = maybeList.length;
          });
        }
      }
    } catch (e) {
      // do nothing
    }
  }
}
