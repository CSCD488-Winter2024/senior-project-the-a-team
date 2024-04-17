import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreatePostEventPage extends StatefulWidget {
  const CreatePostEventPage({super.key});

  @override
  State<CreatePostEventPage> createState() => _CreatePostEventPageState();
}

class _CreatePostEventPageState extends State<CreatePostEventPage> {
  // Text editing controllers to capture input from text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Map<String, bool> tags = {
    'Eastern': false,
    'Traffic': false,
    'Accident': false,
    'Weather': false,
    'Construction': false,
    'Event': false,
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

  void _submitPost() {
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

    // Validate date format using a try-catch to catch any parsing errors
    try {
      final date = DateFormat('yyyy-MM-dd').parseStrict(_dateController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid date format')),
      );
      return; // Exit if the date format is incorrect
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

    // Proceed with form submission if all validations pass
    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    print('Address: ${_addressController.text}');
    print('Date: ${_dateController.text}');
    print('Time: ${_timeController.text}');

    // Clear the fields
    _titleController.clear();
    _descriptionController.clear();
    _addressController.clear();
    _dateController.clear();
    _timeController.clear();

    // Show a snackbar as feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Padding(
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
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
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
                    new FocusNode()); // to prevent keyboard from appearing
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
                    new FocusNode()); // to prevent keyboard from appearing
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
    );
  }
}
