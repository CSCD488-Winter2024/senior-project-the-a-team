import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/widgets/post_widgets/post.dart';
import 'package:wtc/widgets/map_card.dart';
import 'package:flutter_map/flutter_map.dart';

class OrganizationList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final MapController mapController;
  OrganizationList({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('users')
            .where('tier', isEqualTo: 'Poster')
            .where('isBusiness', isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              var document = snapshot.data?.docs[index];
              GeoPoint coordinates = document?['coordinates'] as GeoPoint;
              return MapCard(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                name: document?['name'] as String,
                description: document?['about'] as String,
                address: document?['address'] as String,
                emailAddress: document?['email'] as String,
                businessHours:
                    document?['businessHours'] as Map<String, dynamic>,
                profilePic: document?['pfp'] as String,
                mapController: mapController,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          );
        });
  }
}
