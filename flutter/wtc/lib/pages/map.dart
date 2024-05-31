import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wtc/widgets/map_card.dart';
import 'package:wtc/widgets/map_pin.dart';
import 'package:wtc/widgets/organization_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

MapController mapController = MapController();

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

void updateCoordinates(double latitude, double longitude) {}

class _MapPage extends State<MapPage> {
  LatLng center = LatLng(47.50595337523408, -117.56739882687351);
  double zoom = 12.0;
  List<MapCard> organizations = List<MapCard>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    fetchOrganizations();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(children: [
      Stack(
        children: [
          Text("size of orgs: ${organizations.length}"),
          Container(
              width: 500,
              height: 400,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: zoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                      markers: organizations.map((mapCard) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(mapCard.latitude, mapCard.longitude),
                      child: MapPin(
                        name: mapCard.name,
                        address: mapCard.address,
                        description: mapCard.description,
                        userEmail: mapCard.emailAddress,
                        businessHours: mapCard.businessHours,
                      ),
                    );
                  }).toList()),
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            zoom = 12.0;
                          });
                          mapController.move(center, 12.0);
                          mapController.rotate(0);
                        },
                        child: const Icon(Icons.refresh)),
                    ElevatedButton(
                        onPressed: () {
                          showInstructions(context);
                        },
                        child: const Icon(Icons.info))
                  ]))
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                zoom += 1.0;
              });

              mapController.move(mapController.camera.center, zoom);
            },
            child: const Icon(Icons.zoom_in),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  zoom -= 1.0;
                });
                mapController.move(mapController.camera.center, zoom);
              },
              child: const Icon(Icons.zoom_out)),
        ],
      ),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Title(
            title: "Organizations",
            color: theme.primaryColor,
            child: const Text(
              "Organizations",
              style: TextStyle(fontSize: 20),
            ),
          )),
      Flexible(
          flex: 1,
          child: SizedBox.expand(
            child: OrganizationList(mapController: mapController),
          ))
    ]);
  }

  void showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(
            "How to use",
            textAlign: TextAlign.center,
          ),
          contentPadding: EdgeInsets.all(12),
          content: Text(
              "Pinch the map or press the magnification buttons to zoom in or out.\n\nTo reset default view, press the refresh button in the upper left corner.\n\nTo view an organization, search the organization list below and tap on an organization to navigate to the designated map pin.\n\nTap a map pin to view extended information of an organization."),
        );
      },
    );
  }

  Future<void> fetchOrganizations() async {
    CollectionReference organizations =
        FirebaseFirestore.instance.collection('businesses');

    Query query = organizations;

    QuerySnapshot querySnapshot = await query.get();
    final filteredData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      this.organizations = filteredData.map((data) {
        GeoPoint coordinates = data['coordinates'];
        return MapCard(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
          name: data['name'],
          description: data['about'],
          address: data['address'],
          emailAddress: data['email'],
          businessHours: data['businessHours'],
          profilePic: data['pfp'],
          mapController: mapController,
        );
      }).toList();
    });
  }
}
