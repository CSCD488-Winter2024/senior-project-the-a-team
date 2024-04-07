import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight;

  const TopBar({Key? key, required this.preferredHeight}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Welcome to Cheney'),
      //Drawer handles the rest
    );
  }
}
