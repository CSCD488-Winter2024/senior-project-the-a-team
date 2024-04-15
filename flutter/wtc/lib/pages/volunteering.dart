
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/User/user.dart';
import 'package:wtc/widgets/volunteer_post/volunteer_list.dart';
import 'package:wtc/widgets/job_post/job_post.dart';


User user =
    User(userId: Guid.newGuid, username: "TestUser", email: "TestUser@wtc.org");


JobPost v1 = JobPost(
  title: "Grocer Guy",
  body: "Come be a grocer buy for free! This is a job designed to rob you of your dignity.",
  tags: const["food/drink", "volunteer", "slave labor"],
  postId: Guid.newGuid,
  header: "Grocery man is needed around here.",
  user: user,
  interestCount: 245,
  created: DateTime.now(),
  volunteer: true,
);

JobPost v2 = JobPost(
  title: "Food Bank Thief",
  body: "We need a guy who will pose as a thief at the local food bank. You will be compensated with a bottle of water.",
  tags: const["food/drink"],
  postId: Guid.newGuid,
  header: "Food Bank Thief Needed",
  user: user,
  interestCount: 25,
  created: DateTime.now(),
  volunteer: true,
  wageType: "salary",
  wage: 50000,
);

class VolunteerPage extends StatefulWidget {
  const VolunteerPage({Key? key}) : super(key: key);

  @override
  State<VolunteerPage> createState() => _VolunteerPage();
}

class _VolunteerPage extends State<VolunteerPage> {
  
  List<JobPost> volunteerList = [v1, v2];
  
  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
          child: VolunteerPostList(
          volunteerList: volunteerList
      )),
    );
  }
}