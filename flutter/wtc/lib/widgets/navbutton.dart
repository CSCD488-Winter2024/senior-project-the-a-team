import 'package:flutter/material.dart';

class NavButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final IconData outlinedIcon;

  const NavButton({
    super.key, required this.label, required this.icon, required this.outlinedIcon,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      
      selectedIcon: Icon(widget.icon, color: Colors.black),
      icon: Icon(widget.outlinedIcon, color: Colors.white),
      label: widget.label,
    );
  }
}
