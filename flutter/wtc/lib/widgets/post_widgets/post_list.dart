import 'package:flutter/material.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

const Post post1 = Post(
  title: "Test1",
  body:
      "Lets see what happens when I write a huge amount of text. I mean like really write an absurd amount of text just to test this simple little feature. Because I need to be sure that this will work as it is intended too.",
  tags: ["tag1", "tag2"],
  isAlert: false,
  isEvent: false,
);
const Post post2 = Post(
  title: "Test2",
  body: "This is a test",
  tags: ["tag1", "tag2"],
  isAlert: false,
  isEvent: false,
);
const Post post3 = Post(
  title: "Test3",
  body: "This is a test",
  tags: ["tag1", "tag2"],
  isAlert: false,
  isEvent: false,
);
const Post post4 = Post(
  title: "Test3",
  body: "This is a test",
  tags: ["tag1", "tag2"],
  isAlert: false,
  isEvent: false,
);
const Post post5 = Post(
  title: "Test3",
  body: "This is a test",
  tags: ["tag1", "tag2"],
  isAlert: false,
  isEvent: false,
);
const Post post6 = Post(
  title: "Test3",
  body: "This is a test",
  tags: ["tag1", "tag2"],
  isAlert: false,
  isEvent: false,
);
const Post post7 = Post(
  title: "Test3",
  body: "This is a test",
  tags: ["tag1", "tag2"],
  isAlert: false,
  isEvent: false,
);
const Post post8 = Post(
  title: "Test3",
  body: "This is a test",
  tags: ["tag1", "tag2"],
  isAlert: false,
  isEvent: false,
);
const Post post9 = Post(
  title: "Test3",
  body: "This is a test",
  tags: ["tag1", "tag2"],
  isAlert: false,
  isEvent: false,
);
const Post post10 = Post(
  title: "Test3",
  body: "This is a test",
  tags: ["tag1", "tag2"],
  isAlert: false,
  isEvent: false,
);
const Post post11 = Post(
  title: "Test3",
  body: "This is a test",
  tags: ["tag1", "tag2"],
  isAlert: false,
  isEvent: false,
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
        return Column(
          children: [
            Text(posts[index].title),
            Text('${posts[index].tags}'),
            Text(posts[index].body)
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
