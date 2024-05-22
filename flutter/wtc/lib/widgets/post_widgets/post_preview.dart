import 'package:flutter/material.dart';
import 'package:wtc/user/user.dart';

class PostPreview extends StatelessWidget {
  final String title;
  final User user;
  final DateTime created;

  const PostPreview({
    Key? key,
    required this.title,
    required this.user,
    required this.created,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int month = created.month;
    int day = created.day;
    int year = created.year;
    String username = user.username;
    return Row(
      children: [
        const Padding(
            padding: EdgeInsets.all(16),
            child: Image(
                image: AssetImage('images/emptypfp.png'),
                height: 64,
                width: 64)),
        Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "$username posted: $title",
                    textAlign: TextAlign.center,
                    softWrap: true,
                  )),
            ),
            Text('$day-$month-$year')
          ],
        )
      ],
    );
  }
}
