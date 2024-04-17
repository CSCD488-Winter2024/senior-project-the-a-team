import 'package:flutter/material.dart';
import 'package:wtc/pages/accountsettings.dart';
class EditTags extends StatefulWidget {
  const EditTags({super.key});

  @override
  State<EditTags> createState() => _EditTagsState();
}

class _EditTagsState extends State<EditTags> {

  get tags => acc.tags;
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
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const Text("Edit Tags Page"),
                Text("Current Tags: $tags")
              ]
            )
          ),
        ),
      )
    );
  }
}