import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/widgets/event_widgets/event.dart';
import 'package:wtc/widgets/job_post/job_post.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

class SavedPostsList extends StatefulWidget {
  final String? uid;
  const SavedPostsList({super.key, required this.uid});

  @override
  _SavedPostsListState createState() => _SavedPostsListState();
}

class _SavedPostsListState extends State<SavedPostsList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<dynamic> savedPosts = [];
  late DocumentSnapshot user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPostIDs();
    });
  }

  Future<void> fetchPostIDs() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users')
          .doc(widget.uid).get();
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

      if (data.containsKey('saved_posts') && data['saved_posts'] is List) {
        List<dynamic> savedPostIDs = data['saved_posts'];
        setState(() {
          savedPosts = savedPostIDs;
        });
      }
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: _firestore
            .collection('_posts')
            .orderBy('timestamp', descending: true)
            .snapshots(), builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                } 
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No posts found"));
                }

                // Filter documents to only those in savedPosts
                List<DocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
                  return savedPosts.contains(doc.id);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text("No saved posts found"));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: savedPosts.length,
                  itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = filteredDocs[index];
                      Map<String, dynamic> postData = document.data() as Map<String, dynamic>;
                      String type = postData['type'] as String;
                      String dateCreated = postData['createdAt'] as String;

                     
                      if (type == "Event") {
                        var tempTags = document['tags'] as List<dynamic>;
                        List<String> postTags = [];

                        for (int i = 0; i < tempTags.length; i++) {
                          postTags.add(tempTags[i]);
                        }
                        String dateOfEvent = document['eventDate'] as String;
                        String timeOfEvent = document['eventTime'] as String;
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
                          title: document['title'] as String,
                          body: document['body'] as String,
                          tags: postTags,
                          header: document['header'] as String,
                          interestCount: document['interestCount'] as int,
                          created: DateTime(
                              int.parse(dateCreated.split("-")[0]),
                              int.parse(dateCreated.split("-")[1]),
                              int.parse(dateCreated.split("-")[2])),
                          postId: Guid(document['postID'] as String),
                          userEmail: document['user'] as String,
                          date: DateTime(
                              int.parse(dateOfEvent.split("-")[0]),
                              int.parse(dateOfEvent.split("-")[1]),
                              int.parse(dateOfEvent.split("-")[2])),
                          time: TimeOfDay(hour: hour, minute: minute),
                          location: document['address'] as String,
                          attendingCount: document['attendingCount'] as int,
                          maybeCount: document['maybeCount'] as int,
                        );
                      } else if (type == "Job") {
                        var wage = document['wage'];
                        if (wage is int) {
                          wage = wage.toDouble();
                        }
                        return JobPost(
                          title: document['title'] as String,
                          body: document['body'] as String,
                          tags: const ["Job"],
                          header: document['header'] as String,
                          userEmail: document['user'] as String,
                          interestCount: document['interestCount'] as int,
                          created: DateTime(
                              int.parse(dateCreated.split("-")[0]),
                              int.parse(dateCreated.split("-")[1]),
                              int.parse(dateCreated.split("-")[2])),
                          postId: Guid(document['postID'] as String),
                          wage: wage,
                          wageType: document['wageType'] as String,
                        );
                      } else if (type == "Volunteer") {
                        return JobPost(
                          title: document['title'] as String,
                          body: document['body'] as String,
                          tags: const ["Volunteer"],
                          header: document['header'] as String,
                          userEmail: document['user'] as String,
                          interestCount: document['interestCount'] as int,
                          created: DateTime(
                              int.parse(dateCreated.split("-")[0]),
                              int.parse(dateCreated.split("-")[1]),
                              int.parse(dateCreated.split("-")[2])),
                          postId: Guid(document['postID'] as String),
                          volunteer: true,
                        );
                      } else {
                        var tempTags = document['tags'] as List<dynamic>;
                        List<String> postTags = [];

                        for (int i = 0; i < tempTags.length; i++) {
                          postTags.add(tempTags[i]);
                        }
                        return Post(
                          postId: Guid(document['postID'] as String),
                          header: document['header'] as String,
                          userEmail: document['user'] as String,
                          interestCount: document['interestCount'] as int,
                          created: DateTime(
                              int.parse(dateCreated.split("-")[0]),
                              int.parse(dateCreated.split("-")[1]),
                              int.parse(dateCreated.split("-")[2])),
                          title: document['title'] as String,
                          tags: postTags,
                          body: document['body'] as String,
                        );
                      }
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                        );

            });
  }
}
