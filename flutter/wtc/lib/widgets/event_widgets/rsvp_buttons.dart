import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RSVPButtons extends StatefulWidget {


  const RSVPButtons({super.key});

  @override
  State<StatefulWidget> createState() => _RSVPButtons();
  
}

class _RSVPButtons extends State<RSVPButtons> {
  bool isAttending = false;
  bool isMaybeAttending = false;
  void changeIsAttending() {
    setState(() {
      isAttending = !isAttending;
      if (isMaybeAttending) {
        isMaybeAttending = false;
      }
    });
  }

  void changeIsMaybeAttending() {
    setState(() {
      isMaybeAttending = !isMaybeAttending;
      if (isAttending) {
        isAttending = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [IconButton(iconSize: 36, onPressed: () {changeIsAttending();}, icon: isAttending ? 
    const Icon(color: Colors.green,Icons.check_box) : const Icon(color: Colors.green, Icons.check_box_outlined)),
    IconButton(color: const Color.fromARGB(255, 160, 146, 21),iconSize: 38, onPressed: () {changeIsMaybeAttending();}, icon: isMaybeAttending ? 
    const Icon(Icons.star_rounded) : const Icon(Icons.star_outline_rounded))]);
  }
  
}