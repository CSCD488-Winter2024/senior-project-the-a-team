import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> fetchUserTier() async {
    User? currentUser = auth.currentUser;
    if (currentUser != null && currentUser.email != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDetails =
            await firestore.collection("users").doc(currentUser.uid).get();
        String tier = userDetails.data()?['tier'] ??
            'viewer'; // Default to 'viewer' if not found
        return tier;
      } catch (e) {
        // Handle errors or log them
        print("Error fetching user tier: $e");
        return 'viewer'; // Return default tier in case of error
      }
    } else {
      return 'viewer'; // Return default tier if user is not logged in or email is null
    }
  }
}
