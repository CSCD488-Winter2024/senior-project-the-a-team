import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:wtc/widgets/user_widgets/change_tier_radio_buttons.dart';
import 'package:wtc/widgets/user_widgets/search_user_info.dart';

class SearchUserDeleteEdit extends StatefulWidget {
  const SearchUserDeleteEdit(
      {super.key, required this.user, required this.onUpdatePage});

  final SearchUserInfo user;
  final ValueChanged<void> onUpdatePage;

  @override
  State<SearchUserDeleteEdit> createState() => _SearchUserDeleteEditState();
}

class _SearchUserDeleteEditState extends State<SearchUserDeleteEdit> {
  late String newTier;

  @override
  void initState() {
    super.initState();
    newTier = widget.user.tier;
  }

  void _onNewTierChanged(String tier) {
    setState(() {
      newTier = tier;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        OutlinedButton(
            onPressed: () {
              _showDeleteDialog(context);
            },
            child: const Text("Delete User",
                style: TextStyle(fontSize: 24, color: Colors.red))),
        const SizedBox(width: 10),
        OutlinedButton(
            onPressed: () {
              _showEditDialog(context);
            },
            child: const Text("Edit Tier",
                style: TextStyle(fontSize: 24, color: Color(0xFF469AB8)))),
      ]),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: const Text(
                "Delete User",
                textAlign: TextAlign.center,
              ),
              content: const Text(
                  "Are you sure you want to delete this users account?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close", style: TextStyle(fontSize: 24)),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _deleteUser(widget.user.email, widget.user.uid);
                    void noParam;
                    widget.onUpdatePage(noParam);
                  },
                  child: const Text("Confirm",
                      style: TextStyle(fontSize: 24, color: Colors.green)),
                )
              ]);
        });
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: const Text(
                "Edit User Tier",
                textAlign: TextAlign.center,
              ),
              content: const Text("Edit this users account tier?"),
              actions: <Widget>[
                Column(
                  children: [
                    ChangeTierRadioButton(
                      currentTier: widget.user.tier,
                      onValueChanged: _onNewTierChanged,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close",
                              style: TextStyle(fontSize: 24)),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            _editUserTier(widget.user.uid, newTier);
                            void noParam;
                            widget.onUpdatePage(noParam);
                          },
                          child: const Text("Confirm",
                              style:
                                  TextStyle(fontSize: 24, color: Colors.green)),
                        )
                      ],
                    )
                  ],
                )
              ]);
        });
  }

  Future<void> _deleteUser(String email, String uid) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(uid).delete();
      FirebaseFunctions functions = FirebaseFunctions.instance;
      HttpsCallable callable = functions.httpsCallable('deleteUserByEmail');
      await callable.call(<String, dynamic>{
        'identifier': email,
      });
    } catch (error) {
      // do nothing
    }
  }

  Future<void> _editUserTier(String uid, String newTier) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({'tier': newTier});
  }
}
