
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/User/user.dart';
import 'package:wtc/widgets/job_post/job_list.dart';
import 'package:wtc/widgets/job_post/job_post.dart';


User user =
    User(userId: Guid.newGuid, username: "TestUser", email: "TestUser@wtc.org");


JobPost jobPost1 = JobPost(
  title: "Grocer Guy",
  body: "Come be a grocer buy for low pay!",
  tags: const["food/drink", "handicap"],
  postId: Guid.newGuid,
  header: "Grocery man is needed around here.",
  user: user,
  interestCount: 6,
  created: DateTime.now(),
  wage: 9.75,
  wageType: "hourly",
  volunteer: true,
);

JobPost jobPost2 = JobPost(
  title: "Food Bank Thief",
  body: "We need a guy who will pose as a thief at the local food bank. You will be compensated with a bottle of water.",
  tags: const["food/drink"],
  postId: Guid.newGuid,
  header: "Food Bank Thief Needed",
  user: user,
  interestCount: 25,
  created: DateTime.now(),
  volunteer: false,
  wageType: "salary",
  wage: 50000,
);

class JobsPage extends StatefulWidget {
  const JobsPage({Key? key}) : super(key: key);

  @override
  State<JobsPage> createState() => _JobsPage();
}

class _JobsPage extends State<JobsPage> {
  
  List<JobPost> jobsList = [jobPost1, jobPost2];
  
  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
          child: JobPostList(
          jobsList: jobsList
      )),
    );
  }
}