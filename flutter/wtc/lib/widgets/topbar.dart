import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight;

  const TopBar({Key? key, required this.preferredHeight}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredHeight,
      child: AppBar(
        title: const Text('Welcome To Cheney'),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: IconButton(icon: const Icon(Icons.menu), 
        onPressed: () {

        })
      )
      
    );
  }
}
