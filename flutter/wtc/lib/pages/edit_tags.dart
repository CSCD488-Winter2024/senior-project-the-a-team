
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditTags extends StatefulWidget {
  const EditTags({super.key, required this.tags});

   final List<String> tags;  

  @override
  State<EditTags> createState() => _EditTagsState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _EditTagsState extends State<EditTags> {


  final CollectionReference user = _firestore.collection("users");

  User? currentUser = FirebaseAuth.instance.currentUser;

  final items = [
    'News',
    'Weather',
    'Business',
    'Shopping',
    'Eastern',
    'Entertainment',
    'Food',
    'Government',
    'Job',
    'Volunteer',
    'Pets',
    'Public Resources',
    'Schools',
    'Sports',
    'Adult Sports',
    'Youth Sports',
  ];

  Future<void> updateTags(List<String> tags){
    return user.doc(currentUser!.email).update({
      'tags': tags
    });
  }

  @override
  Widget build(BuildContext context) {

    List<String> tempTags = List.of(widget.tags);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            //widget.tags.removeWhere((element) => !tempTags.contains(element));
            setState(() {
              widget.tags.removeWhere((element) => !tempTags.contains(element));
            });
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
        centerTitle: true,
        backgroundColor: const Color(0xFF469AB8),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              const Align(
                //alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Select Tags:",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),  
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: 6.0,
                    alignment: WrapAlignment.center,
                    runSpacing: 3.0,
                    children: items.map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: FilterChip(
                          label: Text(e), 
                          selected: widget.tags.contains(e),
                          onSelected: (bool value) {
                            if(widget.tags.contains(e)){
                              widget.tags.remove(e);
                            }else{
                              widget.tags.add(e);
                            }
                            setState(() {});
                          }
                        )
                      ),
                    ).toList(),         
                  )    
                ),
              ),

              const SizedBox(height: 150,),

              ElevatedButton(
                onPressed: () async{
                  await showDialog(
                    context: context, 
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirm Tags?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('No'),
                          ),

                          TextButton(
                            onPressed: ()async{
                              await updateTags(tempTags);
                              
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Yes'),
                          )
                        ],
                      );
                    }
                  );
                }, 
                child: const Text("Confirm")
              )
            ],
          ),
        ),
      )
    );
  }
}