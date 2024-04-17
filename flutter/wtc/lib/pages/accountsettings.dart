import 'package:flutter/material.dart';
import 'package:wtc/auth/login_or_register.dart';
import 'package:wtc/components/Account.dart';
import 'package:wtc/pages/edit_profile.dart';
import 'package:wtc/pages/edit_tags.dart';

 
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPage();
}

 const Account acc = Account(
  fname: "Jeremy",
  lname: "Clarkson", 
  tags: ['tag1', 'tag2', 'tag7'],
  email: "jclarkson@gmail.com",
  password: "password123",
  profilePic: Image(image: AssetImage('images/jeremy_clarkson.jpg'), fit: BoxFit.cover,),
);



class _AccountPage extends State<AccountPage> {

  // delete
  get fname => acc.fname;
  get lname => acc.lname;
  get tags => acc.tags;
  get email => acc.email;
  get profilePic => acc.profilePic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Center(
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
                    child: profilePic
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
                      'Hello $fname!',
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
                      Text('Full Name:\n $fname $lname',
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
                    Navigator.pop(context);
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => const LoginOrRegister()));
                  },
                  child: const Text("Logout"),
                )
              ],
            ),
          ),
        )
      ) 
    );
  }
}
 
 