import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';

class CreatePostJobPage extends StatefulWidget {
  const CreatePostJobPage({super.key});

  @override
  State<CreatePostJobPage> createState() => _CreatePostJobPageState();
}

class _CreatePostJobPageState extends State<CreatePostJobPage> {
  // Text editing controllers to capture input from text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _wageController = TextEditingController();
  bool _isVolunteer = false;
  String _wageType = 'hourly'; // Default to hourly

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    // Validation checks for required fields
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and description are required')),
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

    if (!_isVolunteer) {
      // Check if wage is empty
      if (_wageController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wage is required')),
        );
        return; // Exit the function if validation fails
      }

      // Check if wage is a valid double
      double? wage = double.tryParse(_wageController.text);
      if (wage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid wage amount')),
        );
        return; // Exit the function if validation fails
      }
    }

    Guid newGuid = Guid.newGuid;
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    User? currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('_posts')
        .doc(newGuid.toString())
        .set({
      'body': _descriptionController.text,
      'header': _headerController.text,
      'title': _titleController.text,
      'type': _isVolunteer ? 'Volunteer' : 'Job',
      'wage': _isVolunteer ? 0 : double.parse(_wageController.text),
      'wageType': _isVolunteer ? 'N/A' : _wageType,
      'isVolunteer': _isVolunteer,
      'createdAt': formattedDate,
      'timestamp': FieldValue.serverTimestamp(),
      'interestCount': 0,
      'postID': newGuid.toString(),
      'user': currentUser!.email,
    });
    // Clear the fields
    _titleController.clear();
    _headerController.clear();
    _descriptionController.clear();
    _tagsController.clear();
    _wageController.clear();

    // Show a success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Job Post'),
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
              SwitchListTile(
                title: const Text('Volunteer Position'),
                value: _isVolunteer,
                onChanged: (bool value) {
                  setState(() {
                    _isVolunteer = value;
                  });
                },
              ),
              if (!_isVolunteer) ...[
                TextField(
                  controller: _wageController,
                  decoration: const InputDecoration(
                    labelText: 'Wage',
                    hintText: 'Enter wage amount',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16.0),
                DropdownButton<String>(
                  value: _wageType,
                  items: <String>['hourly', 'salary'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != null) {
                        _wageType = newValue;
                      }
                    });
                  },
                ),
              ],
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
