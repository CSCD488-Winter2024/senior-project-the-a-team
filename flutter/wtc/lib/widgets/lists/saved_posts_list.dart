import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:wtc/widgets/nav_bar/event_widgets/event.dart';
import 'package:wtc/widgets/job_post/job_post.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

class SavedPostsList extends StatefulWidget {
  final String? uid;
  const SavedPostsList({super.key, required this.uid});

  @override
  // ignore: library_private_types_in_public_api
  _SavedPostsListState createState() => _SavedPostsListState();
}

class _SavedPostsListState extends State<SavedPostsList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<dynamic> savedPosts = [];
  late DocumentSnapshot user;
  Future<List<DocumentSnapshot>>? futurePosts;

  @override
  void initState() {
    super.initState();
    fetchPostIDs();
  }

  Future<void> fetchPostIDs() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(widget.uid).get();
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

      if (data.containsKey('saved_posts') && data['saved_posts'] is List) {
        List<dynamic> savedPostIDs = data['saved_posts'];
        //deleteNonexistingPostIDs(savedPostIDs);
        setState(() {
          savedPosts = savedPostIDs;
          futurePosts = getPosts(savedPosts);
        });
      }
    } catch (e) {
      // do nothing
    }
  }

  Future<List<DocumentSnapshot>> getPosts(List<dynamic> postIds) async {
    List<DocumentSnapshot> posts = [];
    List<dynamic> missingPostIds = [];

    // Fetch all posts
    for (String postId in postIds) {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('_posts').doc(postId).get();

      if (documentSnapshot.exists) {
        posts.add(documentSnapshot);
      } else {
        missingPostIds.add(postId);
      }
    }

    // Process missing posts and update user's saved posts list
    if (missingPostIds.isNotEmpty) {
      try {
        DocumentReference userRef =
            _firestore.collection('users').doc(widget.uid);
        DocumentSnapshot userDoc = await userRef.get();
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        if (userDoc.exists) {
          List<dynamic> savedPostIDs =
              (data['saved_posts'] as List<dynamic>?) ?? [];

          savedPostIDs.removeWhere((postId) => missingPostIds.contains(postId));
          await userRef.update({'saved_posts': savedPostIDs});
        }
      } catch (e) {
        // do nothing
      }
    }

    return posts;
  }

  Future<void> _refreshPosts() async {
    await Future.delayed(const Duration(seconds: 2));
    fetchPostIDs();
  }

  Future<void> updatePostIDs(List<dynamic> newSavedList) async {
    await _firestore
        .collection("users")
        .doc(widget.uid)
        .update({"saved_posts": newSavedList}).catchError((error) {
      // do nothing
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return LiquidPullToRefresh(
              color: const Color(0xFFBD9F4C),
              backgroundColor: const Color(0xFFF0E8D6),
              showChildOpacityTransition: false,
              onRefresh: _refreshPosts,
              child: ListView.separated(
                padding: const EdgeInsets.all(8.0),
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
                      pfp: document?['pfp'] as String,
                      username: document?['username'] as String,
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
                      pfp: document?['pfp'] as String,
                      username: document?['username'] as String,
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
                      pfp: document?['pfp'] as String,
                      username: document?['username'] as String,
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
                      pfp: document?['pfp'] as String,
                      username: document?['username'] as String,
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ));
        });
  }
}
