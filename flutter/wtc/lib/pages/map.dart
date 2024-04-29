import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wtc/widgets/map_card.dart';
import 'package:wtc/User/user.dart';
import 'package:flutter_guid/flutter_guid.dart';

User user =
    User(userId: Guid.newGuid, username: "TestUser", email: "TestUser@wtc.org");

MapController mapController = MapController();

MapCard mapCard1 = MapCard(
    latitude: 47.51088681762052,
    longitude: -117.56603062632779,
    name: "Second Harvest",
    description: "Food Bank",
    address: "1234 E. Sprague Ave",
    mapController: mapController);

MapCard safeway = MapCard(
    latitude: 47.5064666106083,
    longitude: -117.56740089999998,
    name: "Safeway",
    description:
        "Safeway is a restaurant where you can buy food. Jk it's actually a grocery store. Come on down to Safeway and get your groceries!",
    address: "2710 1st St, Cheney",
    mapController: mapController);

List mapCards = <MapCard>[
  safeway,
  mapCard1,
  mapCard1,
  mapCard1,
  mapCard1,
  mapCard1
];

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

void updateCoordinates(double latitude, double longitude) {}

class _MapPage extends State<MapPage> {
  LatLng center = LatLng(47.50595337523408, -117.56739882687351);
  double zoom = 12.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(children: [
      Stack(
        children: [
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
                  const MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(47.50595337523408, -117.56739882687351),
                        child: Icon(Icons.location_pin,
                            color: Colors.red, size: 50.0),
                      ),
                    ],
                  ),
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(14),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      zoom = 12.0;
                    });
                    mapController.move(center, 12.0);
                  },
                  child: const Icon(Icons.refresh)))
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
            child: ListView(children: <MapCard>[
              safeway,
              mapCard1,
              mapCard1,
              mapCard1,
              mapCard1,
              mapCard1
            ]),
          ))
    ]);
  }
}
