import 'package:flutter/material.dart';
import 'package:wtc/pages/organization_post_page.dart';
import 'package:flutter/cupertino.dart';


class MapPin extends StatelessWidget {
  final String address;
  final String name;
  final String description;
  final String userEmail;

  const MapPin({
    super.key,
    required this.address,
    required this.name,
    required this.description,
    required this.userEmail
  });


  @override
  Widget build(BuildContext context) {
    // You can use this method to return a Marker widget
    return  GestureDetector(
      onTap: () {
          showOrganizationDetails(context);
      },
      child: const Icon(Icons.location_pin, color: Colors.red, size: 50.0)
    );
    

  }
  
  void showOrganizationDetails(BuildContext context) {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog( title: Text(name),
        
        contentPadding: const EdgeInsets.all(12),
        content:  Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(padding: const EdgeInsets.all(8), child: Text(address)),
        Padding(padding: const EdgeInsets.all(8), child: Text("About: $description")),
        Padding(padding: const EdgeInsets.all(12), child: GestureDetector(onTap: () {
            Navigator.push(context,
            CupertinoPageRoute(builder: (context) => OrganizationPostPage(userEmail: userEmail, username: name)));
        },child: const Text("Tap here to view posts.", style: TextStyle(decoration: TextDecoration.underline,color: Color.fromARGB(255, 0, 53, 114)))))]));
      });
  }
}
