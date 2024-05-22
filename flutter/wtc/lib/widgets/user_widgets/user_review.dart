import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_guid/flutter_guid.dart';

class UserReview extends StatelessWidget {
  final String about;
  final String address;
  final Map businessHours;
  final String email;
  final bool isBusiness;
  final String name;
  final String phone;
  final String reviewId;

  UserReview({
    required this.about,
    required this.address,
    required this.businessHours,
    required this.email,
    required this.isBusiness,
    required this.name,
    required this.phone,
    required this.reviewId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Review'),
      ),
      body: Column(
        children: <Widget>[
          Text('About: $about'),
          Text('Address: $address'),
          Text('Business Hours: $businessHours'),
          Text('Email: $email'),
          Text('Is Business: $isBusiness'),
          Text('Name: $name'),
          Text('Phone: $phone'),
        ],
      ),
    );
  }

  static Future<List<UserReview>> fetchUsersFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot =
        await firestore.collection('_review_account').get();
    List<UserReview> users = querySnapshot.docs.map((doc) {
      return UserReview(
        about: doc['about'],
        address: doc['address'],
        businessHours: doc['businessHours'],
        email: doc['email'],
        isBusiness: doc['isBusiness'],
        name: doc['name'],
        phone: doc['phone'],
        reviewId: doc.id,
      );
    }).toList();
    return users;
  }
}
