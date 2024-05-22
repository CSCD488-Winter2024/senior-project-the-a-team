import 'package:flutter/material.dart';
import 'package:wtc/pages/organization_post_page.dart';
import 'package:flutter/cupertino.dart';

class MapPin extends StatelessWidget {
  final String address;
  final String name;
  final String description;
  final String userEmail;
  final Map<String, dynamic> businessHours;

  const MapPin(
      {super.key,
      required this.address,
      required this.name,
      required this.description,
      required this.userEmail,
      required this.businessHours});

  @override
  Widget build(BuildContext context) {
    // You can use this method to return a Marker widget
    return GestureDetector(
        onTap: () {
          showOrganizationDetails(context);
        },
        child: const Icon(Icons.location_pin, color: Colors.red, size: 50.0));
  }

  String formatBusinessHours(Map<String, dynamic> hours) {
    // Define the order of days to maintain consistent formatting
    const dayOrder = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    // Generate a sorted list of business hours by days of the week
    return dayOrder.where((day) => hours.containsKey(day)).map((day) {
      // Ensure the hour value is treated as a string
      return "$day: ${hours[day].toString()}";
    }).join('\n');
  }

  void showOrganizationDetails(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(name),
              contentPadding: const EdgeInsets.all(12),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8), child: Text(address)),
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("About: $description")),
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                            "Business Hours:\n\n ${(formatBusinessHours(businessHours))}")),
                    Padding(
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          OrganizationPostPage(
                                              userEmail: userEmail,
                                              username: name)));
                            },
                            child: const Text("Tap here to view posts.",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color.fromARGB(255, 0, 53, 114)))))
                  ]));
        });
  }
}
