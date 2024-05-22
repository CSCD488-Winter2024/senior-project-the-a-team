import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wtc/pages/nav_bar/account_pages/account_upgrade.dart';
import 'package:wtc/pages/nav_bar/account_pages/edit_business.dart';
import 'package:wtc/pages/nav_bar/account_pages/edit_profile.dart';
import 'package:wtc/pages/nav_bar/account_pages/edit_tags.dart';
//import 'package:wtc/auth/login.dart';

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

  // Delete user from tags collection

  for(int i = 0; i < tags.length; i++){
    await FirebaseFirestore.instance
      .collection('tags')
      .doc(tags[i])
      .update({
        'users': FieldValue.arrayRemove([email.toLowerCase()])
      });
  }

  // Delete pfps from storage
  await FirebaseStorage.instance
    .ref()
    .child('profile_pics/$uid')
    .delete();

  // Delete user from auth
  try{
    await FirebaseAuth.instance.currentUser!.delete();
  }on FirebaseAuthException catch(e){
    AlertDialog(
      title: const Text("Error"),
      content: Text(e.code),
    );
  }
}

class _EditSettingsState extends State<EditSettings> {
  @override
  Widget build(BuildContext context) {

    List<String> origTags = [];
    origTags.addAll(widget.tags);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Settings",
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
      body: Center(
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
                onTap: (){
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
    );
  }
}