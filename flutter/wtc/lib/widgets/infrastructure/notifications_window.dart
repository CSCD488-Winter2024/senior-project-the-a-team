import 'package:flutter/material.dart';
import 'package:wtc/widgets/list_widgets/notifications_list.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/user/user.dart';
import 'package:wtc/widgets/post_widgets/post.dart';
import 'package:wtc/widgets/post_widgets/post_preview.dart';

User user =
    User(userId: Guid.newGuid, username: "TestUser", email: "TestUser@wtc.org");

PostPreview post1 = PostPreview(
    title: "The summer bash - Pig out in the park!",
    user: user,
    created: DateTime.now());
PostPreview post2 = PostPreview(
    title: "Starbuck's coffee making competition",
    user: user,
    created: DateTime.now());
PostPreview post3 = PostPreview(
    title: "Cheney highschool's motor bike relay",
    user: user,
    created: DateTime.now());
PostPreview post4 = PostPreview(
    title: "Pizza huts giving away pizza for 200k",
    user: user,
    created: DateTime.now());
PostPreview post5 = PostPreview(
    title: "Relishing the good days at hot dog joes!",
    user: user,
    created: DateTime.now());
PostPreview post6 = PostPreview(
    title: "Safeway stealing the chickens once again.",
    user: user,
    created: DateTime.now());
PostPreview post7 = PostPreview(
    title: "Bakery bill is stealing hot dogs from Hot Dog Joes again!",
    user: user,
    created: DateTime.now());

List<PostPreview> posts = <PostPreview>[
  post1,
  post2,
  post3,
  post4,
  post5,
  post6,
  post7
];

class NotificationsWindow extends StatefulWidget {
  const NotificationsWindow({Key? key}) : super(key: key);

  @override
  State<NotificationsWindow> createState() => _NotificationsWindow();
}

class _NotificationsWindow extends State<NotificationsWindow> {
  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
          child: NotificationList(
        postList: posts,
      )),
    );
  }
}
