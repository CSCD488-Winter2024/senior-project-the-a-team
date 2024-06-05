import 'package:flutter/material.dart';

class PostTitleBox extends StatelessWidget {
  const PostTitleBox({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 69, 45, 40),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
