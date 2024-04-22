import 'package:flutter/material.dart';
import 'package:wtc/widgets/post_widgets/post.dart';
import 'package:wtc/widgets/post_widgets/post_preview.dart';

// ignore: must_be_immutable
class NotificationList extends StatelessWidget {
  List<PostPreview> postList;

  NotificationList({Key? key, required this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PostPreview> notifications = [];

    for (int i = 0; i < postList.length; i++) {
      notifications.add(postList[i]);
    }

    if (postList.isEmpty) {
      return const Padding(
          padding: EdgeInsets.all(80),
          child: Text("All caught up!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic)));
    } else {
      return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemBuilder: (BuildContext context, int index) {
            return PostPreview(
                title: notifications[index].title,
                user: notifications[index].user,
                created: notifications[index].created);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: notifications.length);
    }
  }
}
