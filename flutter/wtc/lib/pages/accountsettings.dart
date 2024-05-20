import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wtc/accountPages/edit_settings.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void signout(){
    FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
        stream: _firestore
          .collection('users')
          .doc(currentUser!.email)
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text("Error: Cannot retrieve account information");
          } else if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();

            String username = user!['username'];
            String name = user['name'];
            String email = user['email'];
            String pfp = user['pfp'];
            String tier = user['tier'];
            var tempTags = user['tags'] as List<dynamic>;
            List<String> tags = [];
            bool isBusiness = user['isBusiness'];
            bool isPending = user['isPending'];
            String? uid = user['uid'];
            if(uid == null){
              FirebaseFirestore.instance
                .collection("users")
                .doc(email)
                .update({
                  'uid': currentUser!.uid,
                });
            }

            for(int i = 0; i < tempTags.length; i++){
              tags.add(tempTags[i]);
            }

            CachedNetworkImage profilePic = CachedNetworkImage(
              imageUrl: pfp,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Image(image: AssetImage('images/profile.jpg')),
              memCacheHeight: 120,
              memCacheWidth: 120,
              fit: BoxFit.cover,
            );

            return Center(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    //pfp
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),                     
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: profilePic
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Display name
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFF469AB8),
                          borderRadius: BorderRadius.all(Radius.circular(250))),
                      child: SizedBox(
                        width: 9999,
                        child: Text('Hello $username!',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Edit Settings
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: 
                              (context) => EditSettings(
                                tier: tier, 
                                email: email, 
                                tags: tags, 
                                isBusiness: isBusiness, 
                                username: username, 
                                name: name, 
                                profilePic: profilePic,
                                uid: currentUser!.uid,
                                isPending: isPending
                              )
                          )
                        );
                      },
                      child: const Text(
                        "Edit Settings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Bio
                    Container(
                      width: 9999,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black)
                        ),
                      child: Column(
                        children: [
                          Text(
                            'Full Name:\n $name',
                            style: const TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            'Email:',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),

             
                    const SizedBox(
                      height: 25,
                    ),

                    //logout
                    ElevatedButton(
                      onPressed: (){
                        showDialog(
                          context: context, 
                          builder: (context){
                            return AlertDialog(
                              title: const Text("Are you sure you want to Logout?"),
                              actions:[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    signout();
                                  },
                                  child: const Text("Yes"),
                                ),
                              ]
                            );
                          }
                        );
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
          } else {
            return const Text("no data");
          }
        },
      ),
    );
  }
}
