import 'package:flutter/material.dart';
import 'package:wtc/widgets/list_widgets/volunteer_list.dart';



class VolunteerPage extends StatefulWidget {
  const VolunteerPage({super.key});

  @override
  State<VolunteerPage> createState() => _VolunteerPage();
}

class _VolunteerPage extends State<VolunteerPage> {
  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
          child: VolunteerPostList())
          );
  }
}
