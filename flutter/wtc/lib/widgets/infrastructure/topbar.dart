import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final double preferredHeight;
  final VoidCallback onNotificationsPressed;
  String title;
  bool showNotifications;
  TopBar(
      {super.key,
      required this.preferredHeight,
      required this.onNotificationsPressed,
      this.showNotifications = false,
      this.title = "Welcome To Cheney"});


  @override
  // ignore: library_private_types_in_public_api
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

 
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF469AB8),
      iconTheme: const IconThemeData(color: Colors.white),
      title: Align(
        widthFactor: 5.0,
        alignment: Alignment.center,
        child: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      actions: [
        Badge(
          alignment: const AlignmentDirectional(0.5, 0),
          label: const Text('3'),
          child: IconButton(
            icon: widget.showNotifications
                ? const Icon(Icons.notifications)
                : const Icon(Icons.notifications_outlined),
            onPressed: widget.onNotificationsPressed,
          ),
        )
      ],
      //Drawer handles the rest
    );
  }
}
