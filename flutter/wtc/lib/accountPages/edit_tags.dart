import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wtc/User/global_user_info.dart';

class EditTags extends StatefulWidget {
  const EditTags({super.key, required this.tags, required this.origTags});

  final List<String> tags;
  final List<String> origTags;

  @override
  State<EditTags> createState() => _EditTagsState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _EditTagsState extends State<EditTags> {
  final CollectionReference user = _firestore.collection("users");

  User? currentUser = FirebaseAuth.instance.currentUser;

  final items = [
    'Construction',
    'News',
    'Weather',
    'Business',
    'Shopping',
    'Eastern',
    'Entertainment',
    'Food',
    'Government',
    'Job',
    'Traffic',
    'Volunteer',
    'Pets',
    'Public Resources',
    'Schools',
    'Sports',
    'Adult Sports',
    'Youth Sports',
  ];

  Future<void> updateTags(List<String> tags) {
    return user.doc(currentUser!.uid).update({'tags': tags});
  }

  Future<void> setTags(List<String> tags, List<String> origTags) async {
    for (int i = 0; i < tags.length; i++) {
      await _firestore.collection('tags').doc(tags[i]).update({
        'users': FieldValue.arrayUnion([currentUser!.email])
      });
    }

    for (int i = 0; i < origTags.length; i++) {
      if (!tags.contains(origTags[i])) {
        await _firestore.collection('tags').doc(origTags[i]).update({
          'users': FieldValue.arrayRemove([currentUser!.email])
        });
      }
    }
  }

  Future<bool?> _showBackDialog() async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('You have unsaved changes.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Nevermind'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Leave'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              if (listEquals(widget.tags, widget.origTags)) {
                Navigator.of(context).pop();
              } else {
                bool shouldPop = await _showBackDialog() ?? false;
                if (shouldPop && context.mounted) {
                  setState(() {
                    widget.tags.clear();
                    widget.tags.addAll(widget.origTags);
                  });
                  Navigator.of(context).pop();
                }
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            "Edit Tags",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF469AB8),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          //child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PopScope(
                canPop: false,
                onPopInvoked: (bool didPop) async {
                  if (didPop) {
                    return;
                  }
                  final bool changes =
                      !listEquals(widget.tags, widget.origTags);
                  if (changes) {
                    final bool shouldPop = await _showBackDialog() ?? false;
                    if (context.mounted && shouldPop) {
                      setState(() {
                        widget.tags.clear();
                        widget.tags.addAll(widget.origTags);
                      });
                      Navigator.of(context).pop();
                    }
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const SizedBox(),
              ),
              const Align(
                //alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Select Tags",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 1.0,
                      alignment: WrapAlignment.center,
                      runSpacing: 4.0,
                      children: items
                          .map(
                            (e) => Padding(
                                padding: const EdgeInsets.all(5),
                                child: FilterChip(
                                    showCheckmark: false,
                                    label: Text(e),
                                    selected: widget.tags.contains(e),
                                    onSelected: (bool value) {
                                      if (widget.tags.contains(e)) {
                                        widget.tags.remove(e);
                                      } else {
                                        widget.tags.add(e);
                                      }
                                      setState(() {});
                                    })),
                          )
                          .toList(),
                    )),
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () async {
                    if (listEquals(widget.tags, widget.origTags)) {
                      Navigator.of(context).pop();
                    } else {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Confirm Tags?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            title: Text('Updating Tags...'),
                                            content: LinearProgressIndicator(),
                                          );
                                        });
                                    await updateTags(widget.tags);
                                    await setTags(widget.tags, widget.origTags);

                                    setState(() {
                                      widget.origTags.clear();
                                      widget.origTags.addAll(widget.tags);
                                      GlobalUserInfo.setData(
                                          'tags', widget.tags);
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text('Tags Updated Successfully'),
                                      duration: Duration(seconds: 3),
                                    ));

                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Yes'),
                                )
                              ],
                            );
                          });
                    }
                  },
                  child: const Text("Confirm")),
              const SizedBox(height: 40)
            ],
          ),
          //),
        ));
  }
}
