import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight;
  final VoidCallback onNotificationsPressed;
  bool showNotifications;
  TopBar(
      {Key? key,
      required this.preferredHeight,
      required this.onNotificationsPressed,
      this.showNotifications = false})
      : super(key: key);

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
        child: Text("Welcome to Cheney", style: TextStyle(color: Colors.white)),
      ),
      actions: [
        Badge(
          alignment: const AlignmentDirectional(0.5, 0),
          label: const Text('3'),
          child: IconButton(
            icon: showNotifications
                ? const Icon(Icons.notifications)
                : const Icon(Icons.notifications_outlined),
            onPressed: onNotificationsPressed,
          ),
        )
      ],
      //Drawer handles the rest
    );
  }
}
