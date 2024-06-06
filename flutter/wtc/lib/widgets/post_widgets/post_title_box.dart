import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostTitleBox extends StatelessWidget {
  const PostTitleBox({
    Key? key,
    required this.title,
    required this.username,
    required this.created,
    required this.pfp,
  }) : super(key: key);

  final String title;
  final String username;
  final DateTime created;
  final String pfp;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 69, 45, 40),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: pfp,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image(
                image: AssetImage('images/profile.jpg'),
                width: 40,
                height: 40,
              ),
              memCacheHeight: 40,
              memCacheWidth: 40,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 8), // Spacing between image and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4), // Small spacing between title and username
                Row(
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Change text color to white
                      ),
                    ),
                    Text(
                      ' · ${created.toString().split(" ")[0]}',
                      style: TextStyle(
                        color: Colors.white, // Change text color to white
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
