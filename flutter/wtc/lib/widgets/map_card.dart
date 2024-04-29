import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapCard extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String name;
  final String description;
  final String address;
  final MapController mapController;
  //need logo

  const MapCard(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.name,
      required this.description,
      required this.address,
      required this.mapController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          mapController.move(LatLng(latitude, longitude), 18.0);
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Image(
                        image: AssetImage('images/emptypfp.png'),
                        height: 64,
                        width: 64)),
                Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            softWrap: true,
                          )),
                    ),
                    Text(address)
                  ],
                )
              ],
            )));
  }
}
