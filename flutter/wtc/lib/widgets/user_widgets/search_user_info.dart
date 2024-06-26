import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wtc/widgets/user_widgets/search_user_delete_edit.dart';

class SearchUserInfo extends StatelessWidget {
  const SearchUserInfo(
      {super.key,
      required this.email,
      required this.username,
      required this.name,
      required this.tier,
      required this.pfp,
      required this.onUpdatePage,
      required this.uid});

  final String email;
  final String username;
  final String name;
  final String tier;
  final String pfp;
  final ValueChanged<void> onUpdatePage;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: pfp,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Image(
                    image: AssetImage('images/profile.jpg'),
                    width: 120,
                    height: 120),
                memCacheHeight: 120,
                memCacheWidth: 120,
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: Column(
                children: [
                  Text(
                    "Email: $email",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Username: $username",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Name: $name",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tier: $tier",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            )
          ],
        ),
        SearchUserDeleteEdit(
          user: this,
          onUpdatePage: onUpdatePage,
        ),
      ],
    );
  }
}
