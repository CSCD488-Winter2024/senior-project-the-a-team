import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalUserInfo {
  static Map<String, dynamic> _data = {};
  static String? _documentId;

  static Future<void> initialize() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user?.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = querySnapshot.docs.first;
        _documentId = document.id;
        _data = document.data() as Map<String, dynamic>;
      } else {
        print('No document found for email: ${user?.email}');
      }
    } catch (e) {
      print('Error fetching document: $e');
    }
  }

  static dynamic getData(String key) {
    return _data[key];
  }

  static void setData(String key, dynamic value) {
    _data[key] = value;
  }

  static Future<void> updateFirestore() async {
    if (_documentId == null) {
      print('No document ID found. Cannot update Firestore.');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_documentId)
          .set(_data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating document: $e');
    }
  }
}
