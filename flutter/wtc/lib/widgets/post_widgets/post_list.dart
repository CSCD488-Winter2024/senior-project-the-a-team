import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:wtc/User/user.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

User user =
    User(userId: Guid.newGuid, username: "TestUser", email: "TestUser@wtc.org");

Post post1 = Post(
  title: "Test1",
  body:
      "Lets see what happens when I write a huge amount of text. I mean like really write an absurd amount of text just to test this simple little feature. Because I need to be sure that this will work as it is intended too.",
  tags: const ["tag1", "tag2", "tag3"],
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
);
Post post2 = Post(
  title: "Test2",
  body: "This is a test",
  tags: const ["tag1", "tag2"],
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
);
Post post3 = Post(
  title: "Test3",
  body: "This is a test",
  tags: const ["tag1", "tag2", "tag7"],
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
);
Post post4 = Post(
  title: "Test4",
  body: "This is a test",
  tags: const ["tag1", "tag2"],
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
);
Post post5 = Post(
  title: "Test5",
  body: "This is a test",
  tags: const ["tag1"],
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
);
Post post6 = Post(
  title: "Test6",
  body: "This is a test",
  tags: const ["tag1", "tag2", "tag4", "tag5"],
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
);
Post post7 = Post(
  title: "Test7",
  body: "This is a test",
  tags: const ["tag1", "tag2"],
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
);
Post post8 = Post(
  title: "Test8",
  body: "This is a test",
  tags: const ["tag1", "tag2"],
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
);
Post post9 = Post(
  title: "Test9",
  body: "This is a test",
  tags: const ["tag1", "tag2"],
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
);
Post post10 = Post(
  title: "Test10",
  body: "This is a test",
  tags: const ["tag1", "tag2"],
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
);
Post post11 = Post(
  title: "Test11",
  body: "This is a test",
  tags: const ["tag1", "tag2"],
  postId: Guid.newGuid,
  header: "The header",
  user: user,
  interestCount: 0,
  created: DateTime.now(),
);

class PostList extends StatelessWidget {
  final List<Post> posts = <Post>[
    post1,
    post2,
    post3,
    post4,
    post5,
    post6,
    post7,
    post8,
    post9,
    post10,
    post11
  ];

  PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return Post(
          postId: posts[index].postId,
          header: posts[index].header,
          user: posts[index].user,
          interestCount: posts[index].interestCount,
          created: posts[index].created,
          title: posts[index].title,
          tags: posts[index].tags,
          body: posts[index].body,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
