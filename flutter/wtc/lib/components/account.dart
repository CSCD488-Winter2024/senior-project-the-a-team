import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account(
    {Key? key,
    required this.fname,
    required this.lname,
    required this.tags,
    required this.email,
    required this.password,
    required this.profilePic})
    : super(key: key);

    final String fname;
    final String lname;
    final List<String> tags;
    final String email;
    final Image profilePic;
    final String password;

    set fname(String fname){
      if(fname.isNotEmpty) {
        this.fname = fname;
      }
    }

    set lname(String lname){
      if(lname.isNotEmpty) {
        this.lname = lname;
      }
    }

    set tags(List<String> tags){
      this.tags = tags;
    }

    set email(String email){
      if(email.isNotEmpty){
        this.email = email;
      }
    }

    set profilePic(Image profilePic){
      this.profilePic = profilePic;
    }

    set password(String password){
      if(password.isNotEmpty && this.password != password){
        this.password = password;
      }
    }

    @override
    Widget build(BuildContext context){
      return Column(
        children: [
          Account(
            fname: fname,
            lname: lname,
            tags: tags,
            email: email,
            password: password,
            profilePic: profilePic,
          ),
        ],
      );
    }
}
