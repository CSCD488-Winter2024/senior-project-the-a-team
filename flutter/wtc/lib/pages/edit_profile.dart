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
    return user.doc(currentUser!.email).update({
      'username': usernameController.text,
      'name': nameController.text,
    });
  }

  Future<void> setPfp(String img){
    return user.doc(currentUser!.email).update({
      'pfp': img
    });
  }

  @override
  Widget build(BuildContext context){

    //Uint8List? picture;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            bool changes = usernameController.text.isNotEmpty || nameController.text.isNotEmpty || 
              passwordController.text.isNotEmpty || confirmPasswordController.text.isNotEmpty;
              
            if(changes){
              await showDialog(
                context: context, 
                builder: (context) {
                  return  AlertDialog(
                    title: const Text("Are you sure? You have unsaved changes"),
                    actions:[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: (){
                          changes = false;
                          Navigator.of(context).pop();
                        },
                        child: const Text("Yes"),
                      ),
                    ]
                  );
                }
              );
            }
            if(!changes){
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
        backgroundColor: const Color(0xFF469AB8),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //Pfp
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
                  )
                )
                :
                SizedBox(
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: widget.profilePic 
                  ),
                ),

                GestureDetector(
                  onTap: () async{
                    final image = await ImagePicker()
                      .pickImage(
                        source: ImageSource.gallery
                      );

                    setState((){
                      selectedImage = File(image!.path);
                    });

                    Reference ref = FirebaseStorage.instance
                      .ref('profilePictures')
                      .child('${widget.uid}.jpg');

                    await ref.putFile(File(image!.path));

                    String newPfp = await ref.getDownloadURL();

                    setPfp(newPfp);
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

                const SizedBox(height: 15,),

                //confirm profile updates
                ElevatedButton(
                  onPressed: () async{

                    bool changes = usernameController.text.isNotEmpty || nameController.text.isNotEmpty || 
                      passwordController.text.isNotEmpty || confirmPasswordController.text.isNotEmpty;

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
                            content: const Text("You're about to make changes to your account",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
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
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text("Confirm Changes"),
                )
              ],
            ),
          )
        )
      ) 
    );
  }      
}