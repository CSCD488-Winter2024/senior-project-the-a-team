import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wtc/widgets/map_card.dart';
import 'package:wtc/User/user.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/widgets/map_pin.dart';

User user =
    User(userId: Guid.newGuid, username: "TestUser", email: "TestUser@wtc.org");

MapController mapController = MapController();

MapCard bimart = MapCard(
    latitude: 47.500505676036504,
    longitude: -117.56262374784019,
    name: "Bi-Mart Membership Discount Stores",
    description: "a general purpose store",
    address: "2221 1st St, Cheney, WA 99004",
    emailAddress: "bimart@gmail.com",
    mapController: mapController);

MapCard safeway = MapCard(
    latitude: 47.5064666106083,
    longitude: -117.56740089999998,
    name: "Safeway",
    description:
        "Safeway is a restaurant where you can buy food. Jk it's actually a grocery store. Come on down to Safeway and get your groceries!",
    address: "2710 1st St, Cheney",
    emailAddress: "safeway@gmail.com",
    mapController: mapController);

MapCard mitchels = MapCard(
    latitude: 47.483255024221855, 
    longitude: -117.58181308827773,
    name: "Mitchell's Harvest Foods",
    description:
        "Mitchell's Harvest Foods has been proudly serving Cheney for the past 300 years. We are a small grocery store, so our prices are pretty unreasonable.",
    address: "116 W 1st St",
    emailAddress: "mitchels@gmail.com",
    mapController: mapController);

MapCard unionMarket = MapCard(
    latitude: 47.492369291352546, 
    longitude: -117.58395630844107, 
    name: "Union Market",
    description:
        "Come get some crappy food for a crappy price. We're the market over at the PUB at EWU!",
    address: "116 Pence Union Building",
    emailAddress: "unionmarket@gmail.com",
    mapController: mapController);

MapCard aceHardware = MapCard(
    latitude: 47.49968278403646, 
    longitude: -117.56351963474647, 
    name: "Ace Hardware",
    description:
        "Ace Harware sells harware or any other nick nacks that are helpful around the house. I bought a hammer there once, it worked great!",
    address: "6 Cheney Spokane Rd",
    emailAddress: "acehardware@gmail.com",
    mapController: mapController);

MapCard cottonWood = MapCard(
    latitude:47.48656972488268,  
    longitude: -117.57592882067053,
    name: "Cottonwood Creek Boutique & Tanning",
    description:
        "Need a tan? Well, you'll be pretty let down with our price to quality ration. Come on down to our shop this week!",
    address: "317 1st St, Cheney, WA 99004",
    emailAddress: "cottonwood@gmail.com",
    mapController: mapController);


List mapCards = <MapCard>[
  safeway,
  bimart,
  mitchels,
  unionMarket,
  aceHardware,
  cottonWood
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
                  MarkerLayer(
                    markers: mapCards.map((mapCard) {
                      return Marker( width: 80.0,
                        height: 80.0,
                        point: LatLng(mapCard.latitude, mapCard.longitude),
                        child: MapPin(name: mapCard.name, address: mapCard.address, description: mapCard.description, userEmail: mapCard.emailAddress),);
                    }).toList()
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
              aceHardware,
              cottonWood,
              unionMarket,
              mitchels,
              bimart
            ]),
          ))
    ]);
  }
}
