import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
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
  late Future<List<String>> _userTagsFuture;

  @override
  void initState() {
    _userTagsFuture = _getUsersTags();
    super.initState();
  }

  Future<List<String>> _getUsersTags() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    var userInfo =
        await _firestore.collection("users").doc(currentUser?.uid).get();
    List<dynamic> userTagsDynamic = userInfo.data()?['tags'];
    List<String> userTags = userTagsDynamic.cast<String>();
    return userTags;
  }

  Future<void> _testRefresh() async {}

  void _refresh() {
    setState(() {
      _userTagsFuture = _getUsersTags();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _userTagsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return PostListNoTags(
            userTags: snapshot.data ?? [],
            refreshPage: _refresh,
          );
        } else {
          List<String> userTags = snapshot.data!;
          return StreamBuilder(
            stream: _firestore
                .collection('_posts')
                .where('tags', arrayContainsAny: userTags)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (snapshot.data!.docs.isEmpty) {
                return PostListNoPosts(
                    userTags: userTags, refreshPage: _refresh);
              }

              return LiquidPullToRefresh(
                color: const Color(0xFF469AB8),
                backgroundColor: const Color(0xffd4bc93),
                onRefresh: _testRefresh,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    var document = snapshot.data?.docs[index];
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
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              );
            },
          );
        }
      },
    );
  }
}
