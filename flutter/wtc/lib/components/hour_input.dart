import 'package:flutter/material.dart';

class HourInput extends StatelessWidget {
  final String day;
  final TextEditingController openHour;
  final TextEditingController closeHour;
  const HourInput({
    super.key,
    required this.day,
    required this.openHour,
    required this.closeHour,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 5000,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        border: Border.all(
          color: Colors.black,
        ),
        //color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          Text(
            "\t\t$day : ",
            style: const TextStyle(
              fontSize: 17,
            ),
          ),


          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Opening'
                ),
                textAlign: TextAlign.center,
                controller: openHour,
              ),
            ),
          ),

          const Text(
            " - ",
            style: TextStyle(
              fontSize: 20,
            ),
          ),


          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Closing',
                ),
                textAlign: TextAlign.center,
                controller: closeHour,
              ),
            ),
          ),

          const SizedBox(width: 5),
        ],
      ),
    );
  }
}