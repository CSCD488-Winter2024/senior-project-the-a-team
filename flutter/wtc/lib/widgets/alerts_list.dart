import 'package:flutter/material.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

// ignore: must_be_immutable
class AlertsList extends StatelessWidget {
  List<Post> postList;

  AlertsList({Key? key, required this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Post> alerts = [];

    for (int i = 0; i < postList.length; i++) {
      if (postList[i].tags.contains("alert")) {
        alerts.add(postList[i]);
      }
    }

    return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          return Post(
            postId: alerts[index].postId,
            header: alerts[index].header,
            user: alerts[index].user,
            interestCount: alerts[index].interestCount,
            created: alerts[index].created,
            title: alerts[index].title,
            tags: alerts[index].tags,
            body: alerts[index].body,
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: alerts.length);
  }
}
