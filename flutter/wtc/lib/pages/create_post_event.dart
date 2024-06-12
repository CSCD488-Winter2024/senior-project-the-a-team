import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/User/global_user_info.dart';

class CreatePostEventPage extends StatefulWidget {
  const CreatePostEventPage({super.key});

  @override
  State<CreatePostEventPage> createState() => _CreatePostEventPageState();
}

class _CreatePostEventPageState extends State<CreatePostEventPage> {
  // Text editing controllers to capture input from text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

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
    _addressController.dispose();
    _dateController.dispose();
    _timeController.dispose();
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
    // Check if any of the required fields are empty
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
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

    // Validate time format
    final timeParts = _timeController.text.split(':');
    if (timeParts.length != 2 ||
        !timeParts[0].isNotEmpty ||
        !timeParts[1].isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid time format')),
      );
      return; // Exit if the time format is incorrect
    }

    // Check if at least one tag is selected
    bool anyTagSelected = tags.values.any((bool isSelected) => isSelected);
    if (!anyTagSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one tag')),
      );
      return; // Exit if no tags are selected
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
    convertedTags.add('Event');

    User? currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('_posts')
        .doc(newGuid.toString())
        .set({
      'body': _descriptionController.text,
      'header': _headerController.text,
      'tags': convertedTags,
      'title': _titleController.text,
      'type': 'Event',
      'address': _addressController.text,
      'eventDate': _dateController.text,
      'eventTime': _timeController.text,
      'createdAt': formattedDate,
      'timestamp': FieldValue.serverTimestamp(),
      'attendingCount': 0,
      'maybeCount': 0,
      'interestCount': 0,
      'postID': newGuid.toString(),
      'user': currentUser!.email,
      'attending': {},
      'maybe': {},
      'username': GlobalUserInfo.getData('username')  ,
      'pfp': GlobalUserInfo.getData('pfp') 
    });

    // Clear the fields
    _titleController.clear();
    _headerController.clear();
    _descriptionController.clear();
    _addressController.clear();
    _dateController.clear();
    _timeController.clear();

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
        title: const Text('Create Event'),
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
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  hintText: 'YYYY-MM-DD',
                ),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  FocusScope.of(context).requestFocus(
                      FocusNode()); // to prevent keyboard from appearing
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  hintText: 'HH:MM',
                ),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  FocusScope.of(context).requestFocus(
                      FocusNode()); // to prevent keyboard from appearing
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    _timeController.text = picked.format(context);
                  }
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: showTags,
                child: const Text('Select Tags'),
              ),
              const SizedBox(height: 32.0),
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
