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

Set<String> tags = <String>{};


class _GettingStartedPageState extends State<GettingStartedPage> {

  File? selectedImage;

  //bool isSelected = false;

  Future<void> setAccountInfo(var tags, String profilePic){
    return FirebaseFirestore.instance
      .collection('users')
      .doc(widget.email.toLowerCase())
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
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 6.0,
                  alignment: WrapAlignment.center,
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
                    FilterChipWidget(chipName: 'School'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 250.0,),

            // confirm selection
            ElevatedButton(
              onPressed: () async{

                if(tags.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('At least one tag must be selected')),
                  );
                  return;
                }
                else{
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
          if(isSelected){
            tags.add(widget.chipName);
          }
          else{
            tags.remove(widget.chipName);
          }
        });
      }
    );
  }
}
