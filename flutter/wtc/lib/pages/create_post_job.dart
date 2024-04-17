import 'package:flutter/material.dart';

class CreatePostJobPage extends StatefulWidget {
  const CreatePostJobPage({super.key});

  @override
  State<CreatePostJobPage> createState() => _CreatePostJobPageState();
}

class _CreatePostJobPageState extends State<CreatePostJobPage> {
  // Text editing controllers to capture input from text fields
  final TextEditingController _titleController = TextEditingController();
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

  void _submitPost() {
    // Validation checks for required fields
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and description are required')),
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

    // If validation passes, proceed with form submission
    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    print('Tags: ${_tagsController.text}');
    if (!_isVolunteer) {
      print('Wage: ${_wageController.text}');
      print('Wage Type: $_wageType');
    }

    // Clear the fields
    _titleController.clear();
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
    );
  }
}
