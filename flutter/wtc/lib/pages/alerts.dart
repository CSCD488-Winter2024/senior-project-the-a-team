import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/User/user.dart';
import 'package:wtc/widgets/alerts_list.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

User user =
    User(userId: Guid.newGuid, username: "TestUser", email: "TestUser@wtc.org");

Post post1 = Post(
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
  title: "Test1",
  body:
      "Lets see what happens when I write a huge amount of text. I mean like really write an absurd amount of text just to test this simple little feature. Because I need to be sure that this will work as it is intended too.",
  tags: ["tag1", "tag2", "tag3", "alert"],
);
Post post2 = Post(
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
  title: "Test2",
  body: "This is a test",
  tags: ["tag1", "tag2"],
);
Post post3 = Post(
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
  title: "Test3",
  body: "This is a test",
  tags: ["tag1", "tag2", "tag7", "alert"],
);
Post post4 = Post(
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
  title: "Test4",
  body: "This is a test",
  tags: ["tag1", "tag2"],
);
Post post5 = Post(
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
  title: "Test5",
  body: "This is a test",
  tags: ["tag1"],
);

List<Post> posts = <Post>[
  post1,
  post2,
  post3,
  post4,
  post5,
];

class AlertsPage extends StatefulWidget {
  const AlertsPage({Key? key}) : super(key: key);

  @override
  State<AlertsPage> createState() => _AlertsPage();
}

class _AlertsPage extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
          child: AlertsList(
        postList: posts,
      )),
    );
  }
}
