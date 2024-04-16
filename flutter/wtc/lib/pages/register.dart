import 'package:flutter/material.dart';
import 'package:wtc/components/button.dart';
import 'package:wtc/components/textfield.dart';

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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void register(){}

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
          ),
        )
      )
    );
  }
}