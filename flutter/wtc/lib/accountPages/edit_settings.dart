import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wtc/accountPages/account_upgrade.dart';
import 'package:wtc/accountPages/edit_business.dart';
import 'package:wtc/accountPages/edit_profile.dart';
import 'package:wtc/accountPages/edit_tags.dart';
import 'package:wtc/auth/delete_account.dart';
import 'package:wtc/auth/link_accounts.dart';
import 'package:wtc/components/settings_button.dart';


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

class _EditSettingsState extends State<EditSettings> {

  final TextEditingController passwordController = TextEditingController();

  final provider = FirebaseAuth.instance.currentUser?.providerData.first;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey key1 = GlobalKey();
  final GlobalKey key2 = GlobalKey();
  final GlobalKey key3 = GlobalKey();
  final GlobalKey key4 = GlobalKey();
  final GlobalKey key5 = GlobalKey(); 
  bool tour = false;
  @override
  void initState() {
    super.initState();
    _fetchTourStatus();
  }
  @override
  void dispose(){
    passwordController.dispose();
    super.dispose();
  }


  Future<void> _fetchTourStatus() async {
  await isTouring(); // wait for isTouring to complete
  if (!tour){
        WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(context).startShowCase([key1,key2,key3,key4,key5]));
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

  String errorPassword = ""; 
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
                Showcase(key: key1, description: "Users can change their profile picture, username, name, and password in Edit Profile.\n\n(Press and hold the button to skip tour)", 
                onTargetLongPress: () {
                  skipTour();
                },
                child: EditButton(
                  route: EditProfile(
                    uid: widget.uid, 
                    name: widget.name,
                    username: widget.username,
                    profilePic: widget.profilePic,
                  ), 
                  icon: const Icon(Icons.person), 
                  text: "Edit Profile",
                )),
        
                const SizedBox(height: 20,),
        
                // edit tags
                Showcase(key: key2, description: "Change the tags to update the different categories of posts relevant to your liking.\n\n(Press and hold the button to skip tour)", 
                onTargetLongPress: () {
                  skipTour();
                },
                child: EditButton(
                  route: EditTags(
                    tags: widget.tags,
                    origTags: origTags,
                  ), 
                  icon: const Icon(Icons.miscellaneous_services), 
                  text: "Edit Tags",
                )),
        
                const SizedBox(height: 20,),
        
                // link accounts
                Showcase(key: key3, 
                onTargetLongPress: () {
                  skipTour();
                },
                description: "Have an external account you want to link to your current account? You can do that here.\n\n(Press and hold the button to skip tour)", 
                child: const LinkAccounts())
               ,
                const SizedBox(height: 20,),
                // acount is business
                if(widget.isBusiness)
                  const EditButton(
                    route: EditBusinessInfo(), 
                    icon: Icon(Icons.business_center), 
                    text: "Edit Business Informaton",
                  ),
        
                  // acount is not business or a poster
                if(!widget.isBusiness && widget.tier == "Viewer"  && !widget.isPending)
                  Showcase(key: key4, description: "Have a business you want to advertise or want to become a certified poster on the app? You can apply to be a poster here. Fill out the necessary application for admin review.\n\n(Press and hold the button to skip tour)", 
                  onTargetLongPress: () {
                    skipTour();
                  },
                  child:
                  EditButton(
                    route: AccountUpgradePage(
                      tier: widget.tier, 
                      name: widget.name, 
                      email: widget.email, 
                      uid: widget.uid
                    ),
                    icon: const Icon(Icons.pending_actions),
                    text: "Apply to become a poster",
                  )),
        
                  // account is a poster but not a business
                if(widget.tier == "Poster" && !widget.isBusiness && !widget.isPending)
                   EditButton(
                    route: AccountUpgradePage(
                      tier: widget.tier, 
                      name: widget.name, 
                      email: widget.email, 
                      uid: widget.uid
                    ),
                    icon: const Icon(Icons.pending_actions),
                    text: "Apply to become a Business",
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
                Showcase(key: key5, description: "You can also delete the app if you no longer want a presence on the application.\n\n(Press and hold the button to skip tour)", 
                onTargetLongPress: () {
                  skipTour();
                },
                onBarrierClick: () {
                  Navigator.pop(context);
                  skipTour();
                },
                child:
                DeleteAccount(
                  email: widget.email, 
                  tags: widget.tags, 
                  uid: widget.uid, 
                  provider: provider, 
                  passwordController: passwordController
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}