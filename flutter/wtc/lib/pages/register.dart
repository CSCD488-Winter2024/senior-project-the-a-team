import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtc/components/button.dart';
import 'package:wtc/components/textfield.dart';
import 'package:wtc/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({
    super.key,
    required this.onTap,
    });

  final void Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
          email: emailController.text, 
          password: passwordController.text
        );

        createUserDocument(userCredential);

        if(context.mounted)Navigator.pop(context);
      } on FirebaseAuthException catch (e){
        Navigator.pop(context);
        displayMessageToUser(e.code , context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async{
    if(userCredential != null && userCredential.user != null){
      await FirebaseFirestore.instance
      .collection("users")
      .doc(userCredential.user!.email)
      .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'name': nameController.text,
        'tier': "Viewer",
        'tags': ['Eastern'],
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
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

                const SizedBox(height: 10,),

                // register
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text("Login Here"),
                ),
              ]
            )
          ),
        )
      )
    );
  }
}