import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';
import 'package:wtc/widgets/user_widgets/global_user_info.dart';

class SpecificFillableFormPage extends StatefulWidget {
  const SpecificFillableFormPage({super.key});

  @override
  State<SpecificFillableFormPage> createState() =>
      _SpecificFillableFormPageState();
}

class _SpecificFillableFormPageState extends State<SpecificFillableFormPage> {
  // Text editing controllers to capture input from text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  Map<String, bool> tags = {
    'News': false,
    'Weather': false,
    'Business': false,
    'Shopping': false,
    'Eastern': false,
    'Entertainment': false,
    'Food': false,
    'Government': false,
    'Pets': false,
    'Public Resources': false,
    'Schools': false,
    'Sports': false,
    'Adult Sports': false,
    'Youth Sports': false,
    'Traffic': false,
    'Construction': false,
  };

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _titleController.dispose();
    _descriptionController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  void showTags() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Tags'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: tags.keys.map((String tag) {
                    return CheckboxListTile(
                      title: Text(tag),
                      value: tags[tag],
                      onChanged: (bool? value) {
                        setState(() {
                          tags[tag] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitPost() async {
    // Check if the title or description fields are empty
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _headerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return; // Exit the function if validation fails
    }

    bool anyTagSelected = tags.values.any((val) => val);
    if (!anyTagSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one tag must be selected')),
      );
      return; // Exit the function if no tags are selected
    }

    Guid newGuid = Guid.newGuid;
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    var convertedTags = [];
    for (String key in tags.keys) {
      if (tags[key] == true) {
        convertedTags.add(key);
      }
    }

    User? currentUser = FirebaseAuth.instance.currentUser;
    String newGuidString = newGuid.toString();

    await FirebaseFirestore.instance
        .collection('_review_posts')
        .doc(newGuidString)
        .set({
      'body': _descriptionController.text,
      'header': _headerController.text,
      'tags': convertedTags,
      'title': _titleController.text,
      'type': 'Post',
      'createdAt': formattedDate,
      'timestamp': FieldValue.serverTimestamp(),
      'interestCount': 0,
      'postID': newGuidString,
      'user': currentUser!.email,
      'pfp': GlobalUserInfo.getData("pfp"),
      'username': GlobalUserInfo.getData("username"),
    });

    // Clear the fields
    _titleController.clear();
    _descriptionController.clear();
    _headerController.clear();
    _tagsController.clear();

    // Show a snackbar as feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post submitted successfully')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _headerController,
                decoration: const InputDecoration(
                  labelText: 'Quick description',
                ),
                minLines: 1,
                maxLines: 2,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                minLines: 1,
                maxLines: 5,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: showTags,
                child: const Text('Select Tags'),
              ),
              //Submit button
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitPost,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
