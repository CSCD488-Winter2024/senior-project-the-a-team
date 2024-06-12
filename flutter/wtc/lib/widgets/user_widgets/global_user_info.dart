import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalUserInfo {
  static Map<String, dynamic> _data = {};

  static Future<void> initialize() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      _data = document.data() as Map<String, dynamic>;
    } catch (e) {
      // do nothing
    }
  }

  static dynamic getData(String key) {
    return _data[key];
  }

  static void setData(String key, dynamic value) {
    _data[key] = value;
  }

  static Future<void> updateFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .set(_data, SetOptions(merge: true));
    } catch (e) {
      // do nothing
    }
  }
}
