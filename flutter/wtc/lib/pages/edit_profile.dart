import 'package:flutter/material.dart';
import 'package:wtc/components/textfield.dart';

class EditProfile extends StatefulWidget{
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile>{

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF469AB8),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // profile picture
                SizedBox(
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: const Image(image: AssetImage('images/profile.jpg'), fit: BoxFit.cover,)
                  ),
                ),
                const Text("Edit Profile Picture"),

                const SizedBox(height: 25,),

                //edit first name
                MyTextField(
                  hintText: 'Change Username', 
                  obscureText: false, 
                  controller: usernameController
                ),

                const SizedBox(height: 10,),

                //edit last name
                MyTextField(
                  hintText: 'Change Name', 
                  obscureText: false, 
                  controller: nameController
                ),

                const SizedBox(height: 25,),

                // edit email
                MyTextField(
                  hintText: 'Edit Email', 
                  obscureText: false, 
                  controller: emailController
                ),

                const SizedBox(height: 10,),

                //confirm email
                MyTextField(
                  hintText: 'Confirm Email', 
                  obscureText: false, 
                  controller: confirmEmailController
                ),

                const SizedBox(height: 25,),

                // edit password
                MyTextField(
                  hintText: 'Change Password', 
                  obscureText: false, 
                  controller: passwordController
                ),

                const SizedBox(height: 10,),
                
                //confirm password
                MyTextField(
                  hintText: 'Confirm Password', 
                  obscureText: false, 
                  controller: confirmPasswordController
                ),

                const SizedBox(height: 15,),

                //confirm profile updates
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Confirm Changes"),
                  )
              ],
            ),
          )
        )
      ),
    );
  }
}