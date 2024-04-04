import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight;

  const TopBar({Key? key, required this.preferredHeight}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Cheney'),
      ),
      drawer: () {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                child: Text('Menu'),
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }(),
    );
  }
}
