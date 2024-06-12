import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapCard extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String name;
  final String description;
  final String address;
  final String emailAddress;
  final String profilePic;
  final MapController mapController;
  final Map<String, dynamic> businessHours;
  //need logo

  const MapCard(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.name,
      required this.description,
      required this.address,
      required this.emailAddress,
      required this.mapController,
      required this.businessHours,
      required this.profilePic});

  @override
  Widget build(BuildContext context) {
    CachedNetworkImage pfp = CachedNetworkImage(
      imageUrl: profilePic,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Image(
          width: 64, height: 64, image: AssetImage('images/profile.jpg')),
      memCacheHeight: 64,
      memCacheWidth: 64,
      fit: BoxFit.cover,
    );

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
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2.0)),
                  child: ClipOval(
                    child: pfp,
                  ),
                ),
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
