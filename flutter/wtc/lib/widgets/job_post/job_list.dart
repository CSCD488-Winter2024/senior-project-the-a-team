import 'package:flutter/material.dart';
import 'package:wtc/widgets/job_post/job_post.dart';


// ignore: must_be_immutable
class JobPostList extends StatelessWidget {
  
  List<JobPost> jobsList;

  JobPostList({super.key, required this.jobsList});

  @override
  Widget build(BuildContext context) {
    List<JobPost> jobs = [];    

    for (int i = 0; i < jobsList.length; i++) {
      if (!jobsList[i].volunteer) {
        jobs.add(jobsList[i]);
      }
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: jobs.length,
      itemBuilder: (BuildContext context, int index) {
        return JobPost(
          postId: jobs[index].postId,
          header: jobs[index].header,
          user: jobs[index].user,
          interestCount: jobs[index].interestCount,
          created: jobs[index].created,
          title: jobs[index].title,
          tags: jobs[index].tags,
          body: jobs[index].body,
          wage: jobs[index].wage,
          wageType: jobs[index].wageType
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
