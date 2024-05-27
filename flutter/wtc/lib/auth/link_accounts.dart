import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wtc/components/square_tile.dart';
import 'package:wtc/helper/helper_functions.dart';
import 'package:wtc/services/auth_services.dart';

class LinkAccounts extends StatefulWidget {
  const LinkAccounts({super.key});

  @override
  State<LinkAccounts> createState() => _LinkAccountsState();
}

class _LinkAccountsState extends State<LinkAccounts> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              title: const Text("Link Accounts"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SquareTile(
                    imagePath: 'images/google.png', 
                    onTap: ()async{
                      try{
                        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                        final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken
                        );
                        await FirebaseAuth.instance.currentUser!
                          .linkWithCredential(credential);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Account linked successfully."),
                          )
                        );
                        Navigator.pop(context);
                      }on FirebaseAuthException catch(e){
                        if(e.code == 'provider-already-linked'){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Google Account already linked."),
                            )
                          );
                        }
                        else if(e.code == 'credential-already-in-use'){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Google Account already in use."),
                            )
                          );
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Sorry, an error occurred."),
                            )
                          );
                        }
                      }
                    }
                  ),
                  SquareTile(
                    imagePath: 'images/apple.png', 
                    onTap: ()async{
                      try{
                        final rawNonce = AuthService().generateNonce();
                        final nonce = AuthService().sha256ofString(rawNonce);
                        final credential = await SignInWithApple.getAppleIDCredential(
                          scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                          ],
                          nonce: nonce,
                        );
                        final oauthCredential = OAuthProvider("apple.com").credential(
                          idToken: credential.identityToken,
                          rawNonce: rawNonce,
                        );
                        await FirebaseAuth.instance.currentUser!
                          .linkWithCredential(oauthCredential);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Account linked successfully."),
                          )
                        );
                        Navigator.pop(context);
                      }on FirebaseAuthException catch(e){
                        if(e.code == 'provider-already-linked'){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Apple Account already linked."),
                            )
                          );
                        }
                        else if(e.code == 'credential-already-in-use'){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Apple Account already in use."),
                            )
                          );
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Sorry, an error occurred."),
                            )
                          );
                        }
                      }
                    }
                  ),
                  SquareTile(
                    imagePath: 'images/email.png', 
                    onTap: ()async{
                      // show dialog to enter email and password
                      String email = "";
                      String password = "";
                      String confirmPassword = "";
                      showDialog(
                        context: context, 
                        builder: (context){
                          return AlertDialog(
                            title: const Text("Link Email Account"),
                            content: SizedBox(
                              height: 250,
                              child: Column(
                                children: [
                                  TextField(
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                    ),
                                    onChanged: (value){
                                      email = value;
                                    },
                                  ),
                                  TextField(
                                    
                                    decoration: const InputDecoration(
                                      labelText: "Password", 
                                    ),
                                    onChanged: (value){
                                      password = value;
                                    },
                                    obscureText: true,
                                  ),

                                  TextField(
                                    decoration: const InputDecoration(
                                      labelText: "Confirm Password",
                                    ),
                                    onChanged: (value){
                                      confirmPassword = value;
                                    },
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async{
                                  if(password != confirmPassword){
                                    displayMessageToUser(
                                      "Passwords do not match.", 
                                      context
                                    );
                                    return;
                                  }
                                  try{
                                    await FirebaseAuth.instance.currentUser!
                                      .linkWithCredential(
                                        EmailAuthProvider.credential(
                                          email: email, 
                                          password: password
                                        )
                                    );
                                    // send verification email
                                    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                                    await FirebaseFirestore.instance.collection('users')
                                      .doc(FirebaseAuth.instance.currentUser!.uid)
                                      .update({
                                        'email': email,
                                      }
                                    );
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Account linked successfully."),
                                      )
                                    );
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context, 
                                      builder: (context){
                                        return AlertDialog(
                                          title: const Text("Verify Email"),
                                          content: const Text("A verification email has been sent to your email. You may have to check your spam folder."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }on FirebaseAuthException catch(e){
                                    if(e.code == 'provider-already-linked'){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Email already linked."),
                                        )
                                      );
                                    }
                                    else if(e.code == 'email-already-in-use'){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Email already in use."),
                                        )
                                      );
                                    }
                                    else if(e.code == 'weak-password'){
                                      displayMessageToUser(
                                        "Password is too weak.", 
                                        context
                                      );
                                      return;
                                    }
                                    else if(e.code == 'invalid-email'){
                                      displayMessageToUser(
                                        "Please enter a valid email.", 
                                        context
                                      );
                                      return;
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("An error occurred. Make sure you entered the correct email and password."),
                                        )
                                      );
                                      Navigator.pop(context);
                                    }
                                    
                                  }
                                },
                                child: const Text("Link"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  )

                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        height: 80,
        child: const Center(
        child:  ListTile(
          leading: Icon(Icons.link),
          title: Text(
            "Link Accounts",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),)
      ),
    );
  }
}