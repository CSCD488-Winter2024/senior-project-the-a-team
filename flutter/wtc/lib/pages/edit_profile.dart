import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtc/components/textfield.dart';
import 'package:wtc/helper/helper_functions.dart';

class EditProfile extends StatefulWidget{
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile>{

  final CollectionReference user = FirebaseFirestore.instance.collection("users");

  String imageURL = "";
  
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async{
    return await FirebaseFirestore.instance.collection("users").doc(currentUser!.email).get();
  }




  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> updateAccount(TextEditingController usernameController, TextEditingController nameController){
    return user.doc(currentUser!.email).update({
      'username': usernameController.text,
      'name': nameController.text,
    });
  }

  void pickPfp() async{
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if(file == null) return;

    String imageName = user.id;

    Reference refRoot = FirebaseStorage.instance.ref();
    Reference refDirImage = refRoot.child('profilePictures');

    Reference refImageToUpload = refDirImage.child(imageName);

    try{

      await refImageToUpload.putFile(File(file.path));

      imageURL = await refImageToUpload.getDownloadURL();
    
    }on FirebaseException catch(error){
      displayMessageToUser(error.code, context);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF469AB8),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          Map<String, dynamic>? user = snapshot.data!.data();

          String username = user!['username'];
          String name = user['name'];
          //String email = user['email']; 
          

       
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // profile picture
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: const Image(image: AssetImage('images/profile.jpg'), fit: BoxFit.cover,)
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        //pickPfp();
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

                    // //edit email
                    // MyTextField(
                    //   hintText: 'Edit Email', 
                    //   obscureText: false, 
                    //   controller: emailController
                    // ),

                    // const SizedBox(height: 10,),

                    // //confirm email
                    // MyTextField(
                    //   hintText: 'Confirm Email', 
                    //   obscureText: false, 
                    //   controller: confirmEmailController
                    // ),

                    // const SizedBox(height: 25,),

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
                          if(usernameController.text.isEmpty){
                            usernameController.text = username;
                          }
                          if(nameController.text.isEmpty){
                            nameController.text = name;
                          }
                          updateAccount(usernameController, nameController);

                          if(passwordController.text.isNotEmpty && passwordController.text == confirmPasswordController.text){
                            await currentUser?.updatePassword(passwordController.text);
                          }
                          Navigator.pop(context);
                        },
                        child: const Text("Confirm Changes"),
                      )
                  ],
                ),
              )
            )
          ); 
        },
      )
    );
  }
}