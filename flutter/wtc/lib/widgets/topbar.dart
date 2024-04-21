import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight;

  const TopBar({Key? key, required this.preferredHeight}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color(0xFF469AB8),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Align(
          widthFactor: 1.3,
          alignment: Alignment.center,
          child: Text(
            "Welcome to Cheney",
            style: TextStyle(color: Colors.white)
          ),
          

        ),
        actions: [IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white,), onPressed: () {

        })],
        //Drawer handles the rest
        );
  }
}
