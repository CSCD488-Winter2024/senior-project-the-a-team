import 'package:flutter/material.dart';

class PostTitleBoxExpanded extends StatelessWidget {
  const PostTitleBoxExpanded({
    super.key,
    required this.title,
    required this.username,
    required this.created,
    required this.pfp,
  });

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  softWrap: true, // Prevent text wrapping
                ),
                const SizedBox(height: 4), // Small spacing between title and username
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Change text color to white
                          fontSize: 15
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                        softWrap: false, // Prevent text wrapping
                      ),
                    ),
                    Text(
                      ' · ${created.toString().split(" ")[0]}',
                      style: const TextStyle(
                        color: Colors.white, // Change text color to white
                        fontSize: 15
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
