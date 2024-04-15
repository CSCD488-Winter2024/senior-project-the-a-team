import 'package:flutter/material.dart';
import 'package:wtc/widgets/job_post/job_post.dart';


// ignore: must_be_immutable
class VolunteerPostList extends StatelessWidget {
  
  List<JobPost> volunteerList;

  VolunteerPostList({super.key, required this.volunteerList});

  @override
  Widget build(BuildContext context) {
    List<JobPost> volunteerPosts = [];    

    for (int i = 0; i < volunteerList.length; i++) {
      if (volunteerList[i].volunteer) {
        volunteerPosts.add(volunteerList[i]);
      }
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: volunteerPosts.length,
      itemBuilder: (BuildContext context, int index) {
        return JobPost(
          postId: volunteerPosts[index].postId,
          header: volunteerPosts[index].header,
          user: volunteerPosts[index].user,
          interestCount: volunteerPosts[index].interestCount,
          created: volunteerPosts[index].created,
          title: volunteerPosts[index].title,
          tags: volunteerPosts[index].tags,
          body: volunteerPosts[index].body,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
