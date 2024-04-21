import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtc/pages/edit_profile.dart';
import 'package:wtc/pages/edit_tags.dart';

 
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPage();
}





class _AccountPage extends State<AccountPage> {

  User? currentUser = FirebaseAuth.instance.currentUser;
  

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async{
    return await FirebaseFirestore.instance.collection("users").doc(currentUser!.email).get();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasError){
            return const Text("Error: Cannot retrieve account information");
          }
          else if(snapshot.hasData){
            Map<String, dynamic>? user = snapshot.data!.data();

            String username = user!['username'];
            String name = user['name'];
            String email = user['email'];

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [

                      //pfp
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: const Image(image: AssetImage('images/profile.jpg'), fit: BoxFit.cover,)
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Display name
                      Container(
                        decoration: const BoxDecoration(
                        color: Color(0xFF469AB8),
                        borderRadius: BorderRadius.all(Radius.circular(250))
                        ),
                        
                        child: SizedBox(
                          width: 9999,
                          child: Text(
                            'Hello $username!',
                            style: const TextStyle(fontSize: 24), 
                            textAlign: TextAlign.center),
                        ),
                      ),

                      const SizedBox(height: 10),

                      //edit tags button
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditTags()));
                        },
                        child: const Text(
                          "Edit Tags",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Bio with edit account button
                      Container(
                        width: 300,
                        height: 225,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          children: [
                            Text('Full Name:\n $name',
                            style: const TextStyle(
                              fontSize: 24
                            ),
                            textAlign: TextAlign.center,
                            ),
                            Text('Email:\n $email',
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                //Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EditProfile()));
                              },
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 10,),

                      //logout
                      ElevatedButton(
                        onPressed: (){
                          FirebaseAuth.instance.signOut();
                        },
                        child: const Text("Logout"),
                      )
                    ],
                  ),
                ),
              )
            );
          }
          else{
            return const Text("no data");
          }
        },
      ),
    );
  }
}
 
 