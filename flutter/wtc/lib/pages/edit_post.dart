import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

class EditPostPage extends StatefulWidget {
  const EditPostPage({super.key, required this.post});

  final Post post;

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  // Text editing controllers to capture input from text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  Map<String, bool> tags = {
    'Eastern': false,
    'Traffic': false,
    'Accident': false,
    'Weather': false,
    'Construction': false,
    'Event': false,
  };
  bool _isAlert = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.post.title;
    _headerController.text = widget.post.header;
    _descriptionController.text = widget.post.body;
    for (String tag in widget.post.tags) {
      if (tags[tag] != null) {
        tags[tag] = true;
      }
    }
  }

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
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: tags.keys.map((String tag) {
                  return CheckboxListTile(
                    title: Text(tag),
                    value: tags[tag],
                    onChanged: (bool? value) {
                      setState(() {
                        // Update the selection state of the tag
                        tags[tag] = value!;
                      });
                    },
                  );
                }).toList(),
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

  Future<void> _updatePost() async {
    // Check if the title or description fields are empty
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _headerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return; // Exit the function if validation fails
    }

    // Check if the text fields have at least 4 characters
    if (_titleController.text.length < 4 ||
        _descriptionController.text.length < 4 ||
        _headerController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Each field must have at least 4 characters')),
      );
      return; // Exit the function if validation fails
    }

    if (_titleController.text.length > 60 ||
        _headerController.text.length > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Title or quick description can have no more than 60 characters.')),
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

    var convertedTags = [];
    for (String key in tags.keys) {
      if (tags[key] == true) {
        convertedTags.add(key);
      }
    }

    await FirebaseFirestore.instance
        .collection('_posts')
        .doc(widget.post.postId.toString())
        .update({
      'body': _descriptionController.text,
      'header': _headerController.text,
      'tags': convertedTags,
      'title': _titleController.text,
    });

    // Clear the fields
    _titleController.clear();
    _descriptionController.clear();
    _headerController.clear();
    _tagsController.clear();

    // Show a snackbar as feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post Updated Successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
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
              CheckboxListTile(
                title: const Text('Alert'),
                value: _isAlert,
                onChanged: (bool? value) {
                  setState(() {
                    _isAlert = value!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: showTags,
                child: const Text('Select Tags'),
              ),
              //Submit button
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _updatePost();
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
