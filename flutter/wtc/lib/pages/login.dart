import 'package:flutter/material.dart';
import 'package:wtc/app.dart';
import 'package:wtc/components/button.dart';
import 'package:wtc/components/textfield.dart';
import 'package:wtc/helper/helper_functions.dart';
import 'package:wtc/pages/accountsettings.dart';
import 'package:wtc/pages/forgot_password.dart';

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

  

  void login(){
    if(emailController.text != acc.email && passwordController.text != acc.password){
      displayMessageToUser("Email:\njclarkson@gmail.com\nPassword:\npassword123", context);
    }
    else{
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const App()));
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
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
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordPage())
                  );
                },
                child: const Text("Forgot Password"),
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
                child: const Text("Register Here"),
              ),
            ]
          ),
        )
      )
    );
  }
}