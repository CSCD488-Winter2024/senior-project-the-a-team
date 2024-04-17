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
        title: const Align(
          widthFactor: 1.3,
          alignment: Alignment.center,
          child: Text(
            "Welcome to Cheney",
          ),
        )
        //Drawer handles the rest
        );
  }
}
