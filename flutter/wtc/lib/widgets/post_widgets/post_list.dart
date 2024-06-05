import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/User/global_user_info.dart';
import 'package:wtc/widgets/event_widgets/event.dart';
import 'package:wtc/widgets/job_post/job_post.dart';
import 'package:wtc/widgets/post_widgets/post.dart';
import 'package:wtc/widgets/post_widgets/postlist_no_posts.dart';
import 'package:wtc/widgets/post_widgets/postlist_no_tags.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<QueryDocumentSnapshot>> _postsFuture;
  late List<String> _userTags;

  @override
  void initState() {
    setState(() {
      _userTags = GlobalUserInfo.getData('tags')?.cast<String>() ?? [];
      _postsFuture = _fetchPosts();
    });
    super.initState();
  }

  Future<List<QueryDocumentSnapshot>> _fetchPosts() async {
    List<String> userTags =
        GlobalUserInfo.getData('tags')?.cast<String>() ?? [];
    var querySnapshot = await _firestore
        .collection('_posts')
        .where('tags', arrayContainsAny: userTags)
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future<void> _refreshPosts() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _postsFuture = _fetchPosts();
    });
  }

  void _refresh() {
    setState(() {
      _postsFuture = _fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userTags.isEmpty) {
      return PostListNoTags(
        userTags: _userTags,
        refreshPage: _refresh,
      );
    } else {
      return FutureBuilder(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.data!.isEmpty) {
            return PostListNoPosts(userTags: _userTags, refreshPage: _refresh);
          }

          return LiquidPullToRefresh(
              color: const Color(0xFF469AB8),
              backgroundColor: const Color(0xffd4bc93),
              onRefresh: _refreshPosts,
              showChildOpacityTransition: false,
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  var document = snapshot.data?[index];
                  String type = document?['type'] as String;
                  String dateCreated = document?['createdAt'] as String;

                  // Use if-else block to return the correct type of Post for the proper formatting
                  if (type == "Event") {
                    var tempTags = document?['tags'] as List<dynamic>;
                    List<String> postTags = tempTags.cast<String>();

                    String dateOfEvent = document?['eventDate'] as String;
                    String timeOfEvent = document?['eventTime'] as String;
                    var time = timeOfEvent.split(' ');
                    int hour = 0;
                    if (time[1] == "PM") {
                      if (time[0].split(":")[0] == "12") {
                        hour = 12;
                      } else {
                        hour = int.parse(time[0].split(":")[0]) + 12;
                      }
                    } else {
                      hour = int.parse(time[0].split(":")[0]);
                    }
                    int minute = int.parse(time[0].split(":")[1]);
                    return Event(
                      title: document?['title'] as String,
                      body: document?['body'] as String,
                      tags: postTags,
                      header: document?['header'] as String,
                      interestCount: document?['interestCount'] as int,
                      created: DateTime(
                          int.parse(dateCreated.split("-")[0]),
                          int.parse(dateCreated.split("-")[1]),
                          int.parse(dateCreated.split("-")[2])),
                      postId: Guid(document?['postID'] as String),
                      userEmail: document?['user'] as String,
                      date: DateTime(
                          int.parse(dateOfEvent.split("-")[0]),
                          int.parse(dateOfEvent.split("-")[1]),
                          int.parse(dateOfEvent.split("-")[2])),
                      time: TimeOfDay(hour: hour, minute: minute),
                      location: document?['address'] as String,
                      attendingCount: document?['attendingCount'] as int,
                      maybeCount: document?['maybeCount'] as int,
                      isMyPost: false,
                    );
                  } else if (type == "Job") {
                    var wage = document?['wage'];
                    if (wage is int) {
                      wage = wage.toDouble();
                    }
                    return JobPost(
                      title: document?['title'] as String,
                      body: document?['body'] as String,
                      tags: const ["Job"],
                      header: document?['header'] as String,
                      userEmail: document?['user'] as String,
                      interestCount: document?['interestCount'] as int,
                      created: DateTime(
                          int.parse(dateCreated.split("-")[0]),
                          int.parse(dateCreated.split("-")[1]),
                          int.parse(dateCreated.split("-")[2])),
                      postId: Guid(document?['postID'] as String),
                      wage: wage,
                      wageType: document?['wageType'] as String,
                      isMyPost: false,
                    );
                  } else if (type == "Volunteer") {
                    return JobPost(
                      title: document?['title'] as String,
                      body: document?['body'] as String,
                      tags: const ["Volunteer"],
                      header: document?['header'] as String,
                      userEmail: document?['user'] as String,
                      interestCount: document?['interestCount'] as int,
                      created: DateTime(
                          int.parse(dateCreated.split("-")[0]),
                          int.parse(dateCreated.split("-")[1]),
                          int.parse(dateCreated.split("-")[2])),
                      postId: Guid(document?['postID'] as String),
                      volunteer: true,
                      isMyPost: false,
                    );
                  } else {
                    var tempTags = document?['tags'] as List<dynamic>;
                    List<String> postTags = tempTags.cast<String>();
                    return Post(
                      postId: Guid(document?['postID'] as String),
                      header: document?['header'] as String,
                      userEmail: document?['user'] as String,
                      interestCount: document?['interestCount'] as int,
                      created: DateTime(
                          int.parse(dateCreated.split("-")[0]),
                          int.parse(dateCreated.split("-")[1]),
                          int.parse(dateCreated.split("-")[2])),
                      title: document?['title'] as String,
                      tags: postTags,
                      body: document?['body'] as String,
                      isMyPost: false,
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ));
        },
      );
    }
  }
}
