import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wtc/components/button.dart';
import 'package:wtc/components/square_tile.dart';
import 'package:wtc/components/textfield.dart';
import 'package:wtc/helper/helper_functions.dart';
import 'package:wtc/auth/welcome_page.dart';
import 'package:wtc/services/auth_services.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose(){
    usernameController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void register() async{
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      )
    );

    if(passwordController.text != confirmPasswordController.text){
      Navigator.pop(context);
      displayMessageToUser("Passwords don't match", context);
    }
    else{

      try{
        UserCredential? userCredential = 
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(), 
          password: passwordController.text.trim()
        );

        //email verification
        await userCredential.user!.sendEmailVerification();

        createUserDocument(userCredential);

        await showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: const Text("Email Verification"),
            content: const Text("A verification email has been sent to your inbox. You may have to check your spam folder."),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: const Text("OK")
              )
            ],
          ) 
        );

        if(context.mounted){
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => IntroPage(uid: userCredential.user!.uid)
            )
          );
        }
      } on FirebaseAuthException catch (e){
        Navigator.pop(context);
        displayMessageToUser(e.code , context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async{
    List<dynamic> newSavedPostList = List.empty();
    if(userCredential != null && userCredential.user != null){
      await FirebaseFirestore.instance
      .collection("users")
      .doc(userCredential.user!.email)
      .set({
        'email': userCredential.user!.email,
        'username': usernameController.text.trim(),
        'name': nameController.text.trim(),
        'tier': "Viewer",
        'pfp': "",
        'tags': [],
        'isBusiness': false,
        'uid': userCredential.user!.uid,
        'isPending': false,
        'saved_posts': newSavedPostList
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);                   
          }, 
          icon: const Icon(Icons.arrow_back_ios_new)
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                // SizedBox(
                //   // height: 150,
                //   width: 99999,
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(40),
                //     child: const Image(
                //       image: AssetImage("images/WTC_BLANK.png"),
                //       fit: BoxFit.fill,
                //     ),
                //   ),
                // ),

                const Text(
                  "Welcome To Cheney",
                  style: TextStyle(fontSize: 24),
                ),

                const SizedBox(height: 15,),

                //username textfield
                MyTextField(
                  hintText: "Username", 
                  obscureText: false, 
                  controller: usernameController
                ),

                const SizedBox(height: 10,),

                //name textfield
                 MyTextField(
                  hintText: "Name", 
                  obscureText: false, 
                  controller: nameController
                ),

                const SizedBox(height: 10,),

                
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

                //confirm password text
                MyTextField(
                  hintText: "Confirm Password", 
                  obscureText: true, 
                  controller: confirmPasswordController
                ),

                const SizedBox(height: 25,),

                //register
                MyButton(
                  text: 'Register', 
                  onTap: register
                ),

                const SizedBox(height: 15,),

                const Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider()
                    ),

                    Text("Or Continue With"),        

                    Expanded(
                      child: Divider()
                    ),
                  ]
                ),

                const SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SquareTile(
                      imagePath: "images/google.png",
                      onTap: (){
                        AuthService().signInWithGoogle();
                        Navigator.pop(context);
                      },
                    ),

                    SquareTile(
                      imagePath: "images/apple.png",
                      onTap: (){
                        AuthService().signInWithApple();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20,),

                

                // register
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);                   
                  },
                  child: const Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                ),
              ]
            )
          ),
        )
      )
    );
  }
}