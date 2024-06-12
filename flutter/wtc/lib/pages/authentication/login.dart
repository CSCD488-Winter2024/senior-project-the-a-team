import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wtc/pages/authentication/forgot_password.dart';
import 'package:wtc/pages/authentication/register.dart';
import 'package:wtc/widgets/components/button.dart';
import 'package:wtc/widgets/components/square_tile.dart';
import 'package:wtc/widgets/components/textfield.dart';
import 'package:wtc/functions/helper_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wtc/widgets/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      storeNotifToken(FirebaseAuth.instance.currentUser!.uid);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'channel-error') {
        displayMessageToUser(
            "Please enter a valid email and password.", context);
      } else if (e.code == 'invalid-credential') {
        displayMessageToUser(
            "Sorry, your email or password was incorrect. Please try again.",
            context);
      } else if (e.code == 'wrong-password') {
        displayMessageToUser(
            "Sorry, your password was incorrect. Please try again.", context);
      } else if (e.code == 'invalid-email') {
        displayMessageToUser("Please enter a valid email.", context);
      } else if (e.code == 'too-many-requests') {
        displayMessageToUser(
            "Sorry, too many requests. Please try again later.", context);
      } else {
        displayMessageToUser(
            "Sorry, an error occurred. Please try again.", context);
      }
    }
  }

  Future<void> storeNotifToken(String uid) async {
    //get user's notif token
    String? token = await FirebaseMessaging.instance.getToken();
    //store it in firestore
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"notificationToken": token});
  }

  @override
  Widget build(BuildContext context) {
    // while(Navigator.canPop(context)){
    //   Navigator.pop(context);
    // }
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
            child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //logo
            SizedBox(
              height: 250,
              width: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: const Image(image: AssetImage("images/wtcLogo.png")),
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // app name
            const Text(
              "Welcome To Cheney",
              style: TextStyle(fontSize: 20),
            ),

            // email textfield
            MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController),

            const SizedBox(
              height: 10,
            ),

            // password text
            MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: passwordController),

            const SizedBox(
              height: 10,
            ),

            //forgor password
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const ForgotPasswordPage()));
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 25,
            ),

            //sign in
            MyButton(text: 'Login', onTap: login),

            const SizedBox(
              height: 15,
            ),

            const Row(
              children: <Widget>[
                Expanded(child: Divider()),
                Text("Or Sign In With"),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagePath: 'images/google.png'),
                SquareTile(
                    onTap: () => AuthService().signInWithApple(),
                    imagePath: 'images/apple.png'),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  child: const Text(
                    "Register Here",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ]),
        ))));
  }
}
