import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wtc/widgets/user_widgets/user_review.dart';
import 'package:flutter_guid/flutter_guid.dart';

class AccountReviewPage extends StatefulWidget {
  const AccountReviewPage({super.key});

  @override
  State<AccountReviewPage> createState() => _AccountReviewPageState();
}

class _AccountReviewPageState extends State<AccountReviewPage> {
  late Future<List<UserReview>> futureUserReviews;

  @override
  void initState() {
    super.initState();
    futureUserReviews = UserReview.fetchUsersFromFirestore();
  }

  void acceptUser(UserReview userReview) async {
    updateUserWithReview(userReview).then((_) {
      deleteUserFromReviewAccount(userReview.reviewId).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("User approved and review deleted successfully!"),
          backgroundColor: Colors.green,
        ));

        // Refresh data or update state as needed
        setState(() {
          futureUserReviews = UserReview.fetchUsersFromFirestore();
        });
      }).catchError((error) {
        // Handle errors from delete operation
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to delete user review: $error"),
          backgroundColor: Colors.red,
        ));
      });
    }).catchError((error) {
      // Handle errors from update operation
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to update user: $error"),
        backgroundColor: Colors.red,
      ));
    });
  }

  void denyUser(String reviewId) {
    deleteUserFromReviewAccount(reviewId).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User review denied and deleted successfully!"),
        backgroundColor: Colors.green,
      ));

      setState(() {
        futureUserReviews = UserReview.fetchUsersFromFirestore();
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to delete user review: $error"),
        backgroundColor: Colors.red,
      ));
    });
  }

  Future<void> updateUserWithReview(UserReview userReview) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference userDoc =
        firestore.collection('users').doc(userReview.email);

    // Update the user's details
    return userDoc.update({
      'email': userReview.email,
      'isBusiness': userReview.isBusiness,
      'name': userReview.name,
      'about': userReview.about,
      'address': userReview.address,
      'businessHours': userReview.businessHours,
      'phone': userReview.phone,
    });
  }

  Future<void> deleteUserFromReviewAccount(String reviewId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference reviewDoc =
        firestore.collection('_review_account').doc(reviewId);

    return reviewDoc.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<UserReview>>(
        future: futureUserReviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                UserReview userReview = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${userReview.name}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text("Email: ${userReview.email}"),
                        Text("Phone: ${userReview.phone}"),
                        Text("Address: ${userReview.address}"),
                        Text("About: ${userReview.about}"),
                        Text(
                            "Business: ${userReview.isBusiness ? 'Yes' : 'No'}"),
                        Text(
                            "Business Hours: ${userReview.businessHours.toString()}"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  denyUser(snapshot.data![index].reviewId),
                              child: Text("Deny"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  acceptUser(snapshot.data![index]),
                              child: const Text("Approve"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No user reviews found"));
          }
        },
      ),
    );
  }
}
