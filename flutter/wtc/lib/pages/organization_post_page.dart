import 'package:flutter/material.dart';
import 'package:wtc/widgets/organization_post_lists.dart';

class OrganizationPostPage extends StatefulWidget {
  
  final String userEmail;
  final String username;

  const OrganizationPostPage({super.key, required this.userEmail, required this.username});

  @override
  State<StatefulWidget> createState() => _OrganizationPostPage();
  
}

class _OrganizationPostPage extends State<OrganizationPostPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBodyBehindAppBar: true, 
           appBar: AppBar(leading: IconButton(onPressed: (){
            Navigator.pop(context);

           },
           icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
           )           
           ),title: 
            Text(style: const TextStyle(color: Colors.white),"Posts by ${widget.username}"),
            centerTitle: true,
           backgroundColor: const Color(0xFF469AB8),
           surfaceTintColor: Colors.transparent,
           scrolledUnderElevation: 0,
           elevation: 0),
           body: SafeArea(child: OrganizationPostList(userEmail: widget.userEmail)));
  }
  
}