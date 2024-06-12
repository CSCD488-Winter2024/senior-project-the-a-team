import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';

class AttendingList extends StatefulWidget {
  final Guid postID;
  final String attendanceMap;
  const AttendingList({super.key, required this.postID, required this.attendanceMap});

  @override
  State<StatefulWidget> createState() => _AttendingList();
}

class _AttendingList extends State<AttendingList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<dynamic> names = [];
  List<dynamic> pfps = [];
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserNames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(names[index]),
              // You can add profile picture here if needed
              leading: CircleAvatar(
              backgroundImage: NetworkImage(pfps[index]),
               ),
            );
          },
        );
  
  }

  Future<void> getUserNames() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('_posts')
          .doc(widget.postID.toString())
          .get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      if (data.containsKey(widget.attendanceMap) && data[widget.attendanceMap] is List) {
        List<dynamic> attendingList = data[widget.attendanceMap];
        List<dynamic> fetchedNames = [];
        List<dynamic> fetchedPfps = [];
        //loop through the attending list, per email in list, search the users collection for the email
        //grab the name and pfp and place into a local list
        for (int i = 0; i < attendingList.length; i++) {
          QuerySnapshot querySnapshot = await _firestore
              .collection('users')
              .where('uid', isEqualTo: attendingList[i])
              .get();
          for (var doc in querySnapshot.docs) {
            fetchedNames.add(doc['name']);
            fetchedPfps.add(doc['pfp']);
          }
        }

        setState(() {
          names = fetchedNames;
          pfps = fetchedPfps;
        });
      }
    } catch (e) {
      // do nothing
    }
  }
}
