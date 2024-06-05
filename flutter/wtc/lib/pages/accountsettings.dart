import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wtc/accountPages/edit_settings.dart';
import 'package:wtc/auth/auth.dart';

// ignore: must_be_immutable
class AccountPage extends StatefulWidget {
  int currentPageIndex;

   AccountPage({super.key,  required this.currentPageIndex});

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool tour = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final provider = FirebaseAuth.instance.currentUser!.providerData.first;
  
  final GlobalKey key1 = GlobalKey();
  final GlobalKey key2 = GlobalKey();
  @override
  void initState() {
    super.initState();
    _fetchTourStatus();

  }

 
  void signout(){
    FirebaseAuth.instance.signOut();
    if(GoogleAuthProvider().providerId == provider.providerId){
      GoogleSignIn().disconnect();
    }
  }

  Future<void> _fetchTourStatus() async {
  await isTouring(); // wait for isTouring to complete
  if (!tour){
        WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(context).startShowCase([key1,key2]));
  }
  }
  void skipTour() {
    ShowCaseWidget.of(context).dismiss();
    setTourStatus(true);

  }

  Future<void> isTouring() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    var userInfo =
        await _firestore.collection("users").doc(currentUser?.uid).get();
    
    setState(() {
      tour = userInfo.data()?['sawTour'];
    });
    
  }

  Future<void> setTourStatus(bool status) async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  
  await _firestore.collection("users").doc(currentUser?.uid).update({
    'sawTour': status
  });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
        stream: _firestore
          .collection('users')
          .doc(currentUser!.uid)
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

            for(int i = 0; i < tempTags.length; i++){
              tags.add(tempTags[i]);
            }

            if (pfp.isEmpty && currentUser?.providerData.first.photoURL != null) {
              FirebaseFirestore.instance
                .collection("users")
                .doc(email)
                .update({
                  'pfp': currentUser!.providerData.first.photoURL, 
                });
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
                    Showcase(key: key1, 
                    targetShapeBorder: const CircleBorder() ,
                    disposeOnTap: true,
                    onTargetClick: () {
                        Navigator.push(context, CupertinoPageRoute(
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
                        setState(() {
                          widget.currentPageIndex = 2;
                        });
                    },
                    onTargetLongPress: () {
                      skipTour();
                    },
                    onBarrierClick: () {
                      Navigator.push(context, CupertinoPageRoute(
                            builder: 
                              (context) => ShowCaseWidget(builder: (context) => EditSettings(
                                tier: tier, 
                                email: email, 
                                tags: tags, 
                                isBusiness: isBusiness, 
                                username: username, 
                                name: name, 
                                profilePic: profilePic,
                                uid: currentUser!.uid,
                                isPending: isPending
                              )) 
                          )
                        );
                        setState(() {
                          widget.currentPageIndex = 2;
                        });
                    },
                    description: "In the Account Settings page, you can view your account information and edit them by tapping the 'settings' button.\n\n(Press and Hold the Settings Button to Skip the Tour) ", 
                    child: OutlinedButton(
                        onPressed: (){
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
                        "Settings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),  
                    )),

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
                          const Text(
                            'Full Name:',
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),

                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
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
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
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
            signout();
            return const AuthPage();
          }
        },
      ),
    );
  }
}
