import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wtc/auth/auth.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({
    super.key,
    required this.email,
    required this.tags,
    required this.uid,
    required this.provider,
    required this.passwordController,
    });

  final String email;
  final List<String> tags;
  final String uid;
  final UserInfo? provider;
  final TextEditingController passwordController;

  Future<void> deleteAccount(String email, List<String> tags, String uid) async{
    //Delete user from users collection
  await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .delete();

  // // Delete user from tags collection

  for(int i = 0; i < tags.length; i++){
    await FirebaseFirestore.instance
      .collection('tags')
      .doc(tags[i])
      .update({
        'users': FieldValue.arrayRemove([email.toLowerCase()])
      });
  }
  // // Delete pfps from storage
  try{
    await FirebaseStorage.instance
      .ref()
      .child("profilePictures/$uid.jpg")
      .delete();
  }on FirebaseException {
    // do nothing
  }
  // Delete user from auth
  try{
    await FirebaseAuth.instance.currentUser!.delete();
  }on FirebaseAuthException{
    // do nothing
  }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        if(GoogleAuthProvider().providerId == provider!.providerId){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: const Text("Delete Account?"),
                content: const Text("This action is irreversible."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      bool confirmed = false;
                      await showDialog(
                        context: context, 
                        builder: (context){
                          return AlertDialog(
                            title: const Text("Are you sure?"),
                            content: const Text(
                              "This will delete your account permanently.",
                              style: TextStyle(
                                color: Color(0xFFC94F0A),
                                fontWeight: FontWeight.bold
                              )
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  confirmed = true;
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      );
                      if(confirmed){
                        try{
                          showDialog(
                            barrierDismissible: false,
                            context: context, 
                            builder: (context){
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          );

                          await FirebaseAuth.instance.currentUser!
                            .reauthenticateWithProvider(GoogleAuthProvider());

                          await deleteAccount(email, tags, uid);
                          await GoogleSignIn().disconnect();
                          Navigator.pushAndRemoveUntil(
                            context, 
                            CupertinoPageRoute(
                              builder: (context) => const AuthPage()
                            ), 
                            (route) => false
                          );                               
                        } on FirebaseAuthException catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.code),
                            )
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
        else if(AppleAuthProvider().providerId == provider!.providerId){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: const Text("Delete Account?"),
                content: const Text("Are you sure you want to delete your account? This action is irreversible"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      bool confirmed = false;
                      await showDialog(
                        context: context, 
                        builder: (context){
                          return AlertDialog(
                            title: const Text("Are you sure?"),
                            content: const Text(
                              "This will delete your account permanently.",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  confirmed = true;
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      );
                      if(confirmed){
                        try{
                          showDialog(
                            barrierDismissible: false,
                            context: context, 
                            builder: (context){
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          );

                          await FirebaseAuth.instance.currentUser!
                            .reauthenticateWithProvider(AppleAuthProvider());

                          // revoke apple token
                          //await FirebaseAuth.instance.revokeTokenWithAuthorizationCode();

                          await deleteAccount(email, tags, uid);                                 
                          Navigator.pushAndRemoveUntil(
                            context, 
                            CupertinoPageRoute(
                              builder: (context) => const AuthPage()
                            ), 
                            (route) => false
                          );                                  
                        } on FirebaseAuthException catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.code),
                            )
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
        else{
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text("Reauthenticate"),
                content: SizedBox(
                  height: 140,
                  child: Column(
                    children: [
                      const Text("Please re-enter your password to delete your account."),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "This action is irreversible.",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        controller: passwordController,
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      passwordController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                      )
                    ),
                  ),
                  TextButton(
                    onPressed: () async{
                      try{
                        showDialog(
                          barrierDismissible: false,
                          context: context, 
                          builder: (context){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        );
                        await FirebaseAuth.instance.currentUser!
                          .reauthenticateWithCredential(
                            EmailAuthProvider.credential(
                              email: email, 
                              password: passwordController.text.trim()
                            )
                        );

                        await deleteAccount(email, tags, uid);
                        Navigator.pushAndRemoveUntil(
                          context, 
                          CupertinoPageRoute(
                            builder: (context) => const AuthPage()
                          ), 
                          (route) => false
                        );
                      }on FirebaseAuthException{ 
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid password"),
                          )
                        );
                        passwordController.clear();
                        Navigator.pop(context);
                      }                             
                    },                   
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.red,
                      )
                    ),
                  ),                         
                ],
              );
            },
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD4BC93),
          borderRadius: BorderRadius.circular(12),
        ),
        height: 80,
        child: const Center(
          child:  ListTile(
            leading: Icon(Icons.delete),
            title: Text(
              "Delete Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}