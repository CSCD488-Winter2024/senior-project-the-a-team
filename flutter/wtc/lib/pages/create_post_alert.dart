import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';
import 'package:wtc/User/global_user_info.dart';


class CreatePostAlertPage extends StatefulWidget {
  const CreatePostAlertPage({super.key});

  @override
  State<CreatePostAlertPage> createState() => _CreatePostAlertPageState();
}

class _CreatePostAlertPageState extends State<CreatePostAlertPage> {
  // Text editing controllers to capture input from text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _headerController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _titleController.dispose();
    _descriptionController.dispose();
    _headerController.dispose();
    super.dispose();
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

    Guid newGuid = Guid.newGuid;
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    var convertedTags = [];

    User? currentUser = FirebaseAuth.instance.currentUser;
    if(GlobalUserInfo.getData('isBusiness')){
      CollectionReference users = FirebaseFirestore.instance.collection('businesses');
      DocumentSnapshot userDoc = await users.doc(currentUser!.uid).get();
      String businessName = userDoc['name'] as String;
      await FirebaseFirestore.instance
          .collection('_posts')
          .doc(newGuid.toString())
          .set({
        'body': _descriptionController.text,
        'header': _headerController.text,
        'tags': convertedTags,
        'title': _titleController.text,
        'type': 'Alert',
        'createdAt': formattedDate,
        'timestamp': FieldValue.serverTimestamp(),
        'interestCount': 0,
        'postID': newGuid.toString(),
        'user': currentUser.email,
        'username': businessName  ,
        'pfp': GlobalUserInfo.getData('pfp') 
      });
    }
    else{
      await FirebaseFirestore.instance
          .collection('_posts')
          .doc(newGuid.toString())
          .set({
        'body': _descriptionController.text,
        'header': _headerController.text,
        'tags': convertedTags,
        'title': _titleController.text,
        'type': 'Alert',
        'createdAt': formattedDate,
        'timestamp': FieldValue.serverTimestamp(),
        'interestCount': 0,
        'postID': newGuid.toString(),
        'user': currentUser!.email,
        'username': GlobalUserInfo.getData('username')  ,
        'pfp': GlobalUserInfo.getData('pfp') 
      });
    }

    // Clear the fields
    _titleController.clear();
    _descriptionController.clear();
    _headerController.clear();

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
