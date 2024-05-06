import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtc/components/textfield.dart';
import 'package:wtc/helper/helper_functions.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      displayMessageToUser("Password reset sent, check your inbox", context);
    } on FirebaseAuthException catch(e){
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);                   
          }, 
          icon: const Icon(Icons.arrow_back_ios_new)
        ),
        backgroundColor: const Color(0xFF469AB8),
        title: const Text(
          "Forgot Password",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Text(
                  "Find your account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),

                const SizedBox(height: 30,),

                const Text(
                  "Enter the email associated with your account",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25,),
              
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                ),

                const SizedBox(height: 25,),

                MaterialButton(
                  onPressed: passwordReset,
                  color: Colors.grey,
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                )
              ]
            ),
          ),
          
        )
      ),
      
    );
  }
}