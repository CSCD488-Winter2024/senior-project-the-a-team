import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GettingStartedPage extends StatefulWidget {
  const GettingStartedPage({super.key, required this.email, required this.username});

  final String email;
  final String username;

  @override
  State<GettingStartedPage> createState() => _GettingStartedPageState();
}

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

class _GettingStartedPageState extends State<GettingStartedPage> {

  File? selectedImage;

  //bool isSelected = false;

  Future<void> setAccountInfo(var tags, String profilePic){
    return FirebaseFirestore.instance
      .collection('users')
      .doc(widget.email)
      .update({
      'tags': tags,
      'pfp': profilePic,
    });
  }


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

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                //alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 3.0,
                  children: <Widget>[
                    FilterChipWidget(chipName: 'Eastern'),
                    FilterChipWidget(chipName: 'Traffic'),
                    FilterChipWidget(chipName: 'Accident'),
                    FilterChipWidget(chipName: 'Weather'),
                    FilterChipWidget(chipName: 'Construction'),
                    FilterChipWidget(chipName: 'Event'),
                    FilterChipWidget(chipName: 'Sports'),
                    FilterChipWidget(chipName: 'News'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 250.0,),

            // confirm selection
            ElevatedButton(
              onPressed: () async{

                var convertedTags = [];
                  for(String key in tags.keys){
                    if(tags[key] == true){
                      convertedTags.add(key);
                    }
                  }

                if(convertedTags.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('At least one tag must be selected')),
                  );
                  return;
                }
                else{
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
                              String profilePic = "";
                              if(selectedImage != null){
                                Reference ref = FirebaseStorage.instance
                                .ref('profilePictures')
                                .child('${widget.username}.jpg');

                                await ref.putFile(File(selectedImage!.path));

                                profilePic = await ref.getDownloadURL();
                              }

                              await setAccountInfo(convertedTags, profilePic);

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
                }
              },
              child: const Text(
                "Finish Setup"
              )
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatefulWidget {
  final String chipName;
  const FilterChipWidget({super.key, required this.chipName});

  @override
  State<FilterChipWidget> createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName), 
      selected: isSelected,
      onSelected: (bool value){
        setState(() {
          isSelected = !isSelected;
          tags[widget.chipName] = isSelected;
        });
      }
    );
  }
}
