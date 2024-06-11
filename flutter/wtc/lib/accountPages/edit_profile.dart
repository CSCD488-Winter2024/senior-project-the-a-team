import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtc/components/textfield.dart';

class EditProfile extends StatefulWidget{
  const EditProfile({super.key, required this.uid, required this.name, required this.profilePic, required this.username});

   final String uid;
   final String name;
   final String username;
   final CachedNetworkImage? profilePic;

  @override
  State<EditProfile> createState() => _EditProfile();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;


class _EditProfile extends State<EditProfile>{

  File? selectedImage;

  final CollectionReference user = _firestore.collection("users");
  
  User? currentUser = FirebaseAuth.instance.currentUser;


  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> updateAccount(TextEditingController usernameController, TextEditingController nameController){
    return user.doc(currentUser!.uid).update({
      'username': usernameController.text,
      'name': nameController.text,
    });
  }

  Future<void> setPfp(String img){
    return user.doc(currentUser!.uid).update({
      'pfp': img
    });
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'You have unsaved changes.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      //backgroundColor: const Color(0xFFF0E8D6),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            bool changes = usernameController.text.isNotEmpty || nameController.text.isNotEmpty || 
              passwordController.text.isNotEmpty || confirmPasswordController.text.isNotEmpty || selectedImage != null;
              
            if(changes){
              bool shouldPop = await _showBackDialog() ?? false;
              if(context.mounted && shouldPop){
                Navigator.of(context).pop();
              }
            }
            if(!changes && context.mounted){
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Edit Profile',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: const Color(0xFFBD9F4C),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white
        ) ,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          
                PopScope(
                  canPop: false,
                  onPopInvoked: (bool didPop) async {
                    if (didPop) {
                      return;
                    }
                    final bool changes = usernameController.text.isNotEmpty || nameController.text.isNotEmpty || 
                      passwordController.text.isNotEmpty || confirmPasswordController.text.isNotEmpty || selectedImage != null;
                    if(changes){
                      final bool shouldPop = await _showBackDialog() ?? false;
                      if (context.mounted && shouldPop) {
                        Navigator.pop(context);
                      }
                    }
                    if(!changes && context.mounted){
                      Navigator.pop(context);
                    }
                  },
                  child: const SizedBox(),
                ),
          
                //Pfp
                selectedImage != null ?
                  Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    shape: BoxShape.circle
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.file(
                      selectedImage!, 
                      fit: BoxFit.cover,
                    ),
                  )
                )
                :
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    shape: BoxShape.circle
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: widget.profilePic,                   
                  ),
                ),
          
                GestureDetector(
                  onTap: () async{
                    final image = await ImagePicker()
                      .pickImage(
                        source: ImageSource.gallery,
                      );
                    final fileSize = await image?.length();
                    if(fileSize! > 5 * 1024 * 1024){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Image size too large"),
                          duration: Duration(seconds: 3),
                        )
                      );
                      return;
                    }
                    setState((){
                      selectedImage = File(image!.path);
                    });
                  },
                  child: const Text("Edit Profile Picture"),
                ),
          
                const SizedBox(height: 25,),
          
                //edit first name
                MyTextField(
                  hintText: 'Change Username', 
                  obscureText: false, 
                  controller: usernameController
                ),
          
                const SizedBox(height: 10,),
          
                //edit last name
                MyTextField(
                  hintText: 'Change Name', 
                  obscureText: false, 
                  controller: nameController
                ),
          
                const SizedBox(height: 25,),
          
                //edit password
                MyTextField(
                  hintText: 'Change Password', 
                  obscureText: true, 
                  controller: passwordController
                ),
          
                const SizedBox(height: 10,),
                      
                //confirm password
                MyTextField(
                  hintText: 'Confirm Password', 
                  obscureText: true, 
                  controller: confirmPasswordController
                ),
          
                const SizedBox(height: 50,),
          
                //confirm profile updates
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF584C33),
                  ),
                  onPressed: () async{
          
                    bool changes = usernameController.text.isNotEmpty || nameController.text.isNotEmpty || 
                      passwordController.text.isNotEmpty || confirmPasswordController.text.isNotEmpty || selectedImage != null;
          
                    if(!changes) {
                      Navigator.of(context).pop();
                    }
                    else{
                      bool confirm = false;
                      await showDialog(
                        context: context, 
                        builder: (context) {
                          return  AlertDialog(
                            title: const Text("Confirmation"),
                            content: const Text("You're about to make changes to your account.",
                            ),
                            actions:[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: (){
                                  confirm = true;
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Yes"),
                              ),
                            ]
                          );
                        }
                      );
          
                      if(confirm){
          
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text('Updating Account...'),
                              content: LinearProgressIndicator(),
                            );
                          }
                        );
          
                        if(selectedImage != null){
                          Reference ref = FirebaseStorage.instance
                            .ref('profilePictures')
                            .child('${widget.uid}.jpg');
          
                          await ref.putFile(File(selectedImage!.path));
          
                          String newPfp = await ref.getDownloadURL();
          
                          setPfp(newPfp);
                        }
          
                        if(usernameController.text.isEmpty){
                          usernameController.text = widget.username;
                        }
                        if(nameController.text.isEmpty){
                          nameController.text = widget.name;
                        }
                          await updateAccount(usernameController, nameController);
          
                        if(passwordController.text.isNotEmpty && passwordController.text == confirmPasswordController.text){
                          await currentUser?.updatePassword(passwordController.text);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Account Updated Successfully"),
                            duration: Duration(seconds: 3),
                          )
                        );
                        if(selectedImage != null){
                          Navigator.of(context).pop();
                        }
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text(
                    "Confirm Changes",
                    style: TextStyle(color: Color(0xFFF0E8D6)),
                  ),
                )
              ],
            ),
          ),
        )
      ) 
    );
  }      
}