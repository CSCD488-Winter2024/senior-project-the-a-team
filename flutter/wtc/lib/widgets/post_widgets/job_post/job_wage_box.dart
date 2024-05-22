import 'package:flutter/material.dart';

class JobWageBox extends StatelessWidget {
  
  final String wageType;
  final double wage;

  const JobWageBox({Key? key, required this.wageType, required this.wage}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    if (wageType == "hourly") {
      return SizedBox(
            width: 600,
            child: Text(
              // ignore: prefer_interpolation_to_compose_strings
              '\$' + wage.toString() +"/hr",
              textAlign: TextAlign.right,
          )
      );
    }
    
    if (wageType == "salary") {
      return SizedBox(
            width: 600,
            child: Text(
              // ignore: prefer_interpolation_to_compose_strings
              "\$"+wage.toString() +"/yr",
              textAlign: TextAlign.right,
          )
      );
    }

    return const Text("");
  
  }
  
}