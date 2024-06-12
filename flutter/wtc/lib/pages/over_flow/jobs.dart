import 'package:flutter/material.dart';
import 'package:wtc/widgets/lists/job_list.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPage();
}

class _JobsPage extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SizedBox.expand(
        child: JobPostList(),
      ),
    );
  }
}
