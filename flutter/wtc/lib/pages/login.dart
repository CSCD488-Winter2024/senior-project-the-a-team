import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtc/components/button.dart';
import 'package:wtc/components/textfield.dart';
import 'package:wtc/helper/helper_functions.dart';
import 'package:wtc/pages/forgot_password.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({
    super.key,
    required this.onTap,
  });
  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  

  void login() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      )
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      if(context.mounted){
        storeNotifToken(emailController.text);
        Navigator.pop(context);
      }
    }
    on FirebaseAuthException catch(e){
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }
  void storeNotifToken(String email) async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    //getNotifPermissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //get user's notif token
    String? token = await FirebaseMessaging.instance.getToken();
    //store it in firestore
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<void> updateUser() {
      return users
        .doc(email)
        .update({'notificationToken': token})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                SizedBox(
                  height: 250,
                  width: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: const Image(image: AssetImage("images/wtcLogo.png")),
                  ),
                ),

                const SizedBox(height: 25,),

                // app name
                const Text(
                  "Welcome To Cheney",
                  style: TextStyle(fontSize: 20),
                ),

                
                // email textfield
                MyTextField(
                  hintText: "Email", 
                  obscureText: false, 
                  controller: emailController
                ),

                const SizedBox(height: 10,),

                // password text
                MyTextField(
                  hintText: "Password", 
                  obscureText: true, 
                  controller: passwordController
                ),

                const SizedBox(height: 10,),

                //forgor password
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordPage())
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                    ),
                  ],
                ),

                const SizedBox(height: 25,),

                //sign in
                MyButton(
                  text: 'Login', 
                  onTap: login
                ),

                const SizedBox(height: 10,),

                // register
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    "Register Here",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  
                ),
              ]
            ),
          )
        )
      )
    );
  }
}