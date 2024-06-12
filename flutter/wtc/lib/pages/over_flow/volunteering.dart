import 'package:flutter/material.dart';
import 'package:wtc/widgets/lists/volunteer_list.dart';

class VolunteerPage extends StatefulWidget {
  const VolunteerPage({super.key});

  @override
  State<VolunteerPage> createState() => _VolunteerPage();
}

class _VolunteerPage extends State<VolunteerPage> {
  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Container(
      color: Colors.white,
      child: SizedBox.expand(
        child: VolunteerPostList(),
      ),
    );
  }
}
