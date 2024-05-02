import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GettingStartedPage extends StatefulWidget {
  const GettingStartedPage({super.key, required this.email, required this.uid});

  final String email;
  final String uid;

  @override
  State<GettingStartedPage> createState() => _GettingStartedPageState();
}



class _GettingStartedPageState extends State<GettingStartedPage> {

  File? selectedImage;

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

  Future<void> setAccountInfo(var tags, String profilePic){
    return FirebaseFirestore.instance
      .collection('users')
      .doc(widget.email.toLowerCase())
      .update({
      'tags': tags,
      'pfp': profilePic,
    });
  }

  List<String> tags = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF469AB8),
        title: const Text(
          "Getting Started",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //pfp selection
              selectedImage != null ?
              SizedBox(
                height: 120,
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
              :
              CircleAvatar(
                radius: 61.5,
                backgroundColor: Colors.black,
                
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: const Image(
                    image: AssetImage('images/profile.jpg'),
                    height: 120,
                    width: 120,
                    
                  )
                ),
              ),

              // select pfp
              GestureDetector(
                    onTap: () async{
                      final image = await ImagePicker()
                        .pickImage(
                          source: ImageSource.gallery
                        );

                      setState((){
                        selectedImage = File(image!.path);
                      });
                    },
                    child: const Text("Edit Profile Picture"),
                  ),

              const SizedBox(height: 45.0,),

              // tags selection
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
                    runSpacing: 1.0,
                    children: items.map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: FilterChip(
                          label: Text(e),
                          selected: tags.contains(e),
                          onSelected: (bool value){
                            if(tags.contains(e)){
                              tags.remove(e);
                            }else{
                              tags.add(e);
                            }
                            setState(() {});
                          }
                        )
                      ),
                    ).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 25.0,),

              // confirm selection
              ElevatedButton(
                onPressed: () async{
                    String profilePic = "";
                    await showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm Settings?'),
                          content: const Text("You can change these settings later"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(), 
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: ()async{
                                if(selectedImage != null){
                                  Reference ref = FirebaseStorage.instance
                                    .ref('profilePictures')
                                    .child('${widget.uid}.jpg');

                                  await ref.putFile(File(selectedImage!.path));

                                  profilePic = await ref.getDownloadURL();
                                }

                                await setAccountInfo(tags, profilePic);

                                tags.clear(); 

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }, 
                              child: const Text("Yes"),
                            )
                          ],
                        );
                      }
                    );
                },
                child: const Text(
                  "Finish Setup"
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
