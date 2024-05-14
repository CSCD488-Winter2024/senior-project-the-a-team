import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchUserInfo extends StatelessWidget {
  const SearchUserInfo(
      {super.key,
      required this.email,
      required this.username,
      required this.name,
      required this.tier,
      required this.pfp});

  final String email;
  final String username;
  final String name;
  final String tier;
  final String pfp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            imageUrl: pfp,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Image(
                image: AssetImage('images/profile.jpg'),
                width: 120,
                height: 120),
            memCacheHeight: 120,
            memCacheWidth: 120,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            Text("Email: $email"),
            const SizedBox(height: 10),
            Text("Username: $username"),
            const SizedBox(height: 10),
            Text("Name: $name"),
            const SizedBox(height: 10),
            Text("Tier: $tier"),
          ],
        )
      ],
    );
  }
}
