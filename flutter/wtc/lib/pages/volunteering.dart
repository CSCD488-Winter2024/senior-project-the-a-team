import 'package:flutter/material.dart';
import 'package:wtc/widgets/volunteer_post/volunteer_list.dart';



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
          );/*Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Center(child: Text("Volunteer")),
          backgroundColor: const Color(0xFF469AB8),
        ),
        body: Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
              child: VolunteerPostList(volunteerList: volunteerList)),
        ));*/
  }
}
