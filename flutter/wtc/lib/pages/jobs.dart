import 'package:flutter/material.dart';
import 'package:wtc/widgets/job_post/job_list.dart';


class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPage();
}

class _JobsPage extends State<JobsPage> {

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
          child: JobPostList())
          );
  }
}
