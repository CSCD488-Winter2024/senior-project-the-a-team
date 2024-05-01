import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtc/helper/helper_functions.dart';
class EditTags extends StatefulWidget {
  const EditTags({super.key});

  @override
  State<EditTags> createState() => _EditTagsState();
}

class _EditTagsState extends State<EditTags> {

  Map<String, bool> tags = {
    'Eastern': false,
    'Traffic': false,
    'Accident': false,
    'Weather': false,
    'Construction': false,
    'Event': false,
    'Sports': false,
    'News': false,
  };

  final CollectionReference user = FirebaseFirestore.instance.collection('users');

  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async{
    return await FirebaseFirestore.instance.collection("users").doc(currentUser!.email).get();
  }

  Future<void> editTags() async {
    bool anyTagSelected = tags.values.any((val) => val);
    if(!anyTagSelected){
      displayMessageToUser("Tags not updated", context);
      return;
    }

    var convertedTags = [];
    for (String key in tags.keys) {
      if (tags[key] == true) {
        convertedTags.add(key);
      }
    }

    await user.doc(currentUser!.email).update({
      'tags': FieldValue.arrayUnion([convertedTags])
    });
    
  }


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
        title: const Text(
          "Edit Tags",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: const Color(0xFF469AB8),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState){
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: tags.keys.map((String tag){
                            return CheckboxListTile(
                              title: Text(tag),
                              value: tags[tag], 
                              onChanged: (bool? value){
                                setState((){
                                  tags[tag] = value!;
                                });
                              }
                            );
                          }).toList(),
                        );
                      },
                    ),
                    MaterialButton(
                      onPressed: (){
                        //editTags;
                        Navigator.pop(context);
                      },
                      color: Colors.grey[500],
                      child: const Text(
                        'Confirm Changes',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ]
                )
              ),
            ),
          );
        }
      ),      
    );
  }
}