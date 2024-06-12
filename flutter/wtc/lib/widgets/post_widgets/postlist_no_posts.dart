import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wtc/pages/nav_bar/account_pages/edit_tags.dart';

class PostListNoPosts extends StatelessWidget {
  const PostListNoPosts(
      {super.key, required this.userTags, required this.refreshPage});

  final List<String> userTags;
  final VoidCallback refreshPage;

  @override
  Widget build(BuildContext context) {
    List<String> origTags = [];
    origTags.addAll(userTags);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
            "There are currently no posts marked with your selected tags.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Try selecting some more tags from the select tags menu. You can get there from the account page by clicking the \"Settings\" button and then clicking \"Edit Tags\" or by clicking the button below.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        EditTags(tags: userTags, origTags: origTags)),
              ).whenComplete(() => refreshPage());
            },
            child: const Text("Edit Your Tags Here!"))
      ],
    );
  }
}
