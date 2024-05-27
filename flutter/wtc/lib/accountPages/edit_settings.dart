import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wtc/accountPages/account_upgrade.dart';
import 'package:wtc/accountPages/edit_business.dart';
import 'package:wtc/accountPages/edit_profile.dart';
import 'package:wtc/accountPages/edit_tags.dart';
import 'package:wtc/auth/auth.dart';
import 'package:wtc/components/square_tile.dart';
import 'package:wtc/services/auth_services.dart';


class EditSettings extends StatefulWidget {
  const EditSettings(
    {
      super.key, 
      required this.tier, 
      required this.email, 
      required this.tags, 
      required this.isBusiness,
      required this.username,
      required this.name,
      required this.profilePic,
      required this.uid,
      required this.isPending
    }
  );

  final String tier;
  final String email;
  final List<String> tags;
  final bool isBusiness;
  final String username;
  final String name;
  final CachedNetworkImage? profilePic;
  final String uid;
  final bool isPending;

  @override
  State<EditSettings> createState() => _EditSettingsState();
}

Future<void> deleteAccount(String email, List<String> tags, String uid) async{
  //Delete user from users collection
  await FirebaseFirestore.instance
    .collection('users')
    .doc(email.toLowerCase())
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


class _EditSettingsState extends State<EditSettings> {

  final TextEditingController passwordController = TextEditingController();

  final provider = FirebaseAuth.instance.currentUser?.providerData.first;

  @override
  void dispose(){
    passwordController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {

    List<String> origTags = [];
    origTags.addAll(widget.tags);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF469AB8),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
        
                // edit profile
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditProfile(
                          uid: widget.uid,
                          name: widget.name,
                          username: widget.username,
                          profilePic: widget.profilePic,
                        )
                      )
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
                      leading: Icon(Icons.person),
                      title: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),)
                  ),
                ),
        
                const SizedBox(height: 20,),
        
                // edit tags
                 GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditTags(
                          tags: widget.tags,
                          origTags: origTags,
                        )
                      )
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
                      leading: Icon(Icons.miscellaneous_services),
                      title: Text(
                        "Edit Tags",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),)
                  ),
                ),
        
                const SizedBox(height: 20,),
        
                // link accounts
                GestureDetector(
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
                                        content: Text("Account linked successfully"),
                                      )
                                    );
                                    Navigator.pop(context);
                                  }on FirebaseAuthException catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.code),
                                      )
                                    );
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
                                        content: Text("Account linked successfully"),
                                      )
                                    );
                                    Navigator.pop(context);
                                  }on FirebaseAuthException catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.code),
                                      )
                                    );
                                  }
                                }
                              ),
                              SquareTile(
                                imagePath: 'images/email.png', 
                                onTap: ()async{
                                  // show dialog to enter email and password
                                  String email = "";
                                  String password = "";
                                  showDialog(
                                    context: context, 
                                    builder: (context){
                                      return AlertDialog(
                                        title: const Text("Link Email Account"),
                                        content: SizedBox(
                                          height: 150,
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
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text("Account linked successfully"),
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
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(e.code),
                                                  )
                                                );
                                                Navigator.pop(context);
                                                
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
                ),
        
                const SizedBox(height: 20,),
        
                // acount is business
                if(widget.isBusiness)
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const EditBusinessInfo()
                        )
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
                        leading: Icon(Icons.business_center),
                        title: Text(
                          "Edit Business Information",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),)
                    ),
                  ),
        
                  // acount is not business or a poster
                if(!widget.isBusiness && widget.tier == "Viewer"  && !widget.isPending)
                  GestureDetector(
                    onTap: (){               
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AccountUpgradePage(
                            tier: widget.tier,
                            name: widget.name,
                            email: widget.email,
                            uid: widget.uid,
                          )
                        )
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
                        leading: Icon(Icons.pending_actions),
                        title: Text(
                          "Apply to become a poster",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                ),
        
                  // account is a poster but not a business
                if(widget.tier == "Poster" && !widget.isBusiness && !widget.isPending)
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AccountUpgradePage(
                            tier: widget.tier,
                            name: widget.name,
                            email: widget.email,
                            uid: widget.uid,
                          )
                        )
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
                        leading: Icon(Icons.business),
                        title: Text(
                          "Apply to become a business",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                ),
        
                if(widget.isBusiness && widget.isPending)
                const SizedBox(height: 20,),
        
                if(widget.isPending)
                GestureDetector(
                    onTap: (){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Your application is pending"),
                        )
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
                        leading: Icon(Icons.pending_actions),
                        title: Text(
                          "Application Pending",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                ),
        
        
                if(widget.tier == "Poster" || widget.tier == "Viewer")
                const SizedBox(height: 20,),
        
                // delete account
                GestureDetector(
                  onTap: ()async{
                    if(GoogleAuthProvider().providerId == provider!.providerId){
                      showDialog(
                        context: context, 
                        builder: (context){
                          return AlertDialog(
                            title: const Text("Delete Account"),
                            content: const Text("Are you sure you want to delete your account? This action is irreversible"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
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
        
                                    await deleteAccount(widget.email, widget.tags, widget.uid);
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
                            title: const Text("Delete Account"),
                            content: const Text("Are you sure you want to delete your account? This action is irreversible"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
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
        
                                    await deleteAccount(widget.email, widget.tags, widget.uid);
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
                            title: const Text("Reauthenticate"),
                            content: SizedBox(
                              height: 120,
                              child: Column(
                                children: [
                                  const Text("Please reauthenticate to delete your account"),
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
                                child: const Text("Cancel"),
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
                                          email: widget.email, 
                                          password: passwordController.text.trim()
                                        )
                                    );
                                    
                                    await deleteAccount(widget.email, widget.tags, widget.uid);
                                    Navigator.pushAndRemoveUntil(
                                      context, 
                                      CupertinoPageRoute(
                                        builder: (context) => const AuthPage()
                                      ), 
                                      (route) => false
                                    );
                                  }on FirebaseAuthException catch(e){ 
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.code),
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
                      color: Colors.grey[300],
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}