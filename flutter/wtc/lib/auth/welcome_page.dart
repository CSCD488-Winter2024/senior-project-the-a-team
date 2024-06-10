import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wtc/User/global_user_info.dart';
import 'package:wtc/auth/auth.dart';
import 'package:wtc/intro_screens/intro_page1.dart';
import 'package:wtc/intro_screens/intro_page2.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key, required this.uid});

  final String uid;

  @override
  State<IntroPage> createState() => _IntroPageState();
}

User? currentUser = FirebaseAuth.instance.currentUser;

class _IntroPageState extends State<IntroPage> {

  final PageController _controller = PageController();

  bool _isLastPage = false;

    File? selectedImage;

  final items = [
    'Construction',
    'News',
    'Weather',
    'Business',
    'Shopping',
    'Eastern',
    'Entertainment',
    'Food',
    'Government',
    'Job',
    'Traffic',
    'Volunteer',
    'Pets',
    'Public Resources',
    'Schools',
    'Sports',
    'Adult Sports',
    'Youth Sports',
  ];

  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> createAccountDoc(var tags, String profilePic) async {
    String? token = await FirebaseMessaging.instance.getToken();
    List<dynamic> newSavedPostList = List.empty();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .set({
      'email': currentUser!.email,
      'username': currentUser!.email!.split('@')[0],
      'name': currentUser!.displayName,
      'tier': "Viewer",
      'isBusiness': false,
      'uid': currentUser!.uid,
      'isPending': false,
      'tags': tags,
      'pfp': profilePic,
      'saved_posts': newSavedPostList,
      'notificationToken': token,
      'sawTour': false,
    }).whenComplete(() async => await GlobalUserInfo.initialize());
  }

  Future<void> setAccountInfo(var tags, String profilePic) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update({
      'tags': tags,
      'pfp': profilePic,
    }).whenComplete(() async => await GlobalUserInfo.initialize());
  }

  Future<void> setTags(var tags) async {
    for (int i = 0; i < tags.length; i++) {
      FirebaseFirestore.instance.collection('tags').doc(tags[i]).update({
        'users': FieldValue.arrayUnion([currentUser!.email])
      });
    }
  }

  List<String> tags = [];

  final provider = FirebaseAuth.instance.currentUser?.providerData.first;

  @override
  Widget build(BuildContext context) {

    Image pfp;

    if (currentUser!.photoURL != null) {
      pfp = Image.network(
        currentUser!.photoURL!,
        fit: BoxFit.cover,
      );
    } else {
      pfp = const Image(
        image: AssetImage("images/profile.jpg"),
        fit: BoxFit.cover,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          const PopScope(
            canPop: false,
            child: SizedBox()
          ),
          PageView(
            onPageChanged: (index){
              setState(() {
                _isLastPage = (index == 2);
              });
            },
            controller: _controller,
            children: [
              const IntroPage1(),
              const IntroPage2(),
              Scaffold(
                backgroundColor: const Color(0xFFBD9F4C),
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        const Text(
                          "Account Setup", 
                          style: TextStyle(
                            color: Colors.black, 
                            fontSize: 24, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 20),
                        //pfp selection
                        selectedImage != null
                            ? SizedBox(
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
                            : Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200), child: pfp),
                              ),

                        // select pfp
                        GestureDetector(
                          onTap: () async {
                            final image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);

                            final fileSize = await image?.length();
                            if(fileSize! > 5 * 1024 * 1024){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Image size must be less than 5MB."),
                                duration: Duration(seconds: 3),
                              ));
                              return;
                            }

                            setState(() {
                              selectedImage = File(image!.path);
                            });
                          },
                          child: const Text(
                            "Edit Profile Picture",
                            style: TextStyle(
                              color: Color(0xFFF0E8D6),
                              fontSize: 16,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 25.0,
                        ),

                        // tags selection
                        const Align(
                          //alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Text(
                              "Select Tags",
                              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Wrap(
                              spacing: 1.0,
                              alignment: WrapAlignment.center,
                              runSpacing: 0,
                              children: items
                                  .map(
                                    (e) => Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: FilterChip(
                                            showCheckmark: false,
                                            backgroundColor: const Color(0xFFF0E8D6),
                                            selectedColor: const Color(0xFF584C33),
                                            label: Text(e),
                                            labelStyle: TextStyle(
                                              color: tags.contains(e) ? const Color(0xFFF0E8D6) : Colors.black,
                                            ),
                                            selected: tags.contains(e),
                                            onSelected: (bool value) {
                                              if (tags.contains(e)) {
                                                tags.remove(e);
                                              } else {
                                                tags.add(e);
                                              }
                                              setState(() {});
                                            })),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20.0,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Container(
            alignment: const Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                _isLastPage ?
                GestureDetector(
                  onTap: (){
                    _controller.jumpToPage(2);
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Color.fromARGB(0, 240, 232, 214),
                      fontSize: 18
                    )
                  )
                )
                :
                GestureDetector(
                  onTap: (){
                    _controller.jumpToPage(2);
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Color(0xFFF0E8D6),
                      fontSize: 18
                    )
                  )
                ),

                SmoothPageIndicator(
                  controller: _controller, 
                  count: 3,
                  effect: const WormEffect(
                    dotColor: Color(0xFFD4BC93),
                    activeDotColor: Color(0xFF584C33),
                  ),
                ),

                _isLastPage ?
                GestureDetector(
                  onTap: ()async {
                    String profilePic = "";
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm Settings?'),
                          content: const Text(
                              "You can change these settings later"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => const Center(
                                          child: CircularProgressIndicator(),
                                        ));
                                if (selectedImage != null) {
                                  Reference ref = FirebaseStorage.instance
                                      .ref('profilePictures')
                                      .child('${widget.uid}.jpg');

                                  await ref
                                      .putFile(File(selectedImage!.path));

                                  profilePic = await ref.getDownloadURL();
                                }

                                if (GoogleAuthProvider().providerId ==
                                        provider!.providerId ||
                                    AppleAuthProvider().providerId ==
                                        provider!.providerId) {
                                  if (selectedImage == null) {
                                    profilePic = currentUser!.photoURL!;
                                  }
                                  await createAccountDoc(tags, profilePic);
                                } else {
                                  await setAccountInfo(tags, profilePic);
                                }

                                await setTags(tags);

                                tags.clear();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const AuthPage()),
                                    (route) => false);
                              },
                              child: const Text("Yes"),
                            )
                          ],
                        );
                      }
                    );
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: Color(0xFFF0E8D6),
                      fontSize: 18
                    )
                  ),
                )
                :
                 GestureDetector(
                   onTap: (){
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 500), 
                      curve: Curves.easeIn
                    );
                  },
                  child: const Text(
                    "Next", 
                    style: TextStyle(
                      color: Color(0xFFF0E8D6),
                      fontSize: 18
                    )
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}