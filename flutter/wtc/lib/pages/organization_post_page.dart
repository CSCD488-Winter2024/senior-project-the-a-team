import 'package:flutter/material.dart';
import 'package:wtc/widgets/organization_post_lists.dart';

class OrganizationPostPage extends StatefulWidget {
  
  final String userEmail;

  const OrganizationPostPage({super.key, required this.userEmail});

  @override
  State<StatefulWidget> createState() => _OrganizationPostPage();
  
}

class _OrganizationPostPage extends State<OrganizationPostPage> {
  
  @override
  Widget build(BuildContext context) {
    return OrganizationPostList(userEmail: widget.userEmail);
  }
  
}