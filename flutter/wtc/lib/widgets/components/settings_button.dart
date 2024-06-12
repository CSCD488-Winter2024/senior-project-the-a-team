import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    super.key,
    required this.route,
    required this.icon,
    required this.text,
    });

  final Widget route;
  final Icon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {
        Navigator.push(
          context, 
          CupertinoPageRoute(
            builder: (context) => route
          )
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD4BC93),
          borderRadius: BorderRadius.circular(12)
        ),
        height: 80,
        child: Center(
          child: ListTile(
            leading: icon,
            title: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        )
      )
    );
  }
}