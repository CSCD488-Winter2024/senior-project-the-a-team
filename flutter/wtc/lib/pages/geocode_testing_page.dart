import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';


class GeocodeTest extends StatefulWidget {
  

  const GeocodeTest({super.key});

  @override
  State<StatefulWidget> createState() => _GeocodeTest();
 
}

class _GeocodeTest extends State<GeocodeTest> {
  double lat = 0;
  double long = 0;
  String address = '6 Cheney Spokane Rd, Cheney WA, Cheney, WA';

  Future<void> getCoordinates() async {
      try {
        List<Location> locations = await locationFromAddress(address);
        Location first = locations.first;
        
        setState(() {
          lat= first.latitude;
          long = first.longitude;
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  

  @override
  Widget build(BuildContext context) {
    return Card(shadowColor: Colors.transparent,
    margin: const EdgeInsets.all(8.0),
    child: Column( children: [Row(children: [ElevatedButton(onPressed: getCoordinates, child: const Text("Get Coords")), Text("latitude: $lat \nlongitude: $long" )],), Text(address)])
    );
  }
}