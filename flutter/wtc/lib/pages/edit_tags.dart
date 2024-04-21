import 'package:flutter/material.dart';
class EditTags extends StatefulWidget {
  const EditTags({super.key});

  @override
  State<EditTags> createState() => _EditTagsState();
}

class _EditTagsState extends State<EditTags> {

  //get tags => acc.tags;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Edit Tags"),
        backgroundColor: const Color(0xFF469AB8),
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Text("Edit Tags Page"),
                Text("Current Tags: ")
              ]
            )
          ),
        ),
      )
    );
  }
}