import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // Text editing controllers to capture input from text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _submitPost() {
    // Here you would typically send the data to a backend or handle it as needed
    // This example simply prints the values to the console
    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    print('Tags: ${_tagsController.text}');

    // Clear the fields
    _titleController.clear();
    _descriptionController.clear();
    _tagsController.clear();

    // Show a snackbar as feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
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
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags(To be replaced with radio buttons)',
              ),
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
    );
  }
}
