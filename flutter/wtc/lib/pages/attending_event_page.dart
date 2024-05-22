import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/widgets/attending_list.dart';

class AttendingEventPage extends StatefulWidget {
  final Guid postID;
  final String attendanceMap;
  final String attending;

  const AttendingEventPage({super.key, required this.postID, required this.attendanceMap, required this.attending, });

  @override
  State<StatefulWidget> createState() => _AttendingEventPage();
}

class _AttendingEventPage extends State<AttendingEventPage> {
  @override
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(color: Colors.white, Icons.arrow_back),
        ),
        backgroundColor: const Color(0xFF469AB8),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Align(
              widthFactor: 2.5,
              child: Text(widget.attending, style: const TextStyle(color: Colors.white),),
              
              )
      ),
      body: SafeArea(
        child: AttendingList(postID: widget.postID, attendanceMap: widget.attendanceMap)
      ),
    );
    


  } 
}

