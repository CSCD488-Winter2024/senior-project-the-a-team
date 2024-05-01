import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget{
  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText, 
    required this.controller
    });

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2000)
        ),
        hintText: hintText
      ),
      obscureText: obscureText,
    );
  }
}