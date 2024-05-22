import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wtc/widgets/user_widgets/search_user_info.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> allUsers = [];
  List<QueryDocumentSnapshot> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    var querySnapshot = await _firestore.collection('users').get();
    setState(() {
      allUsers = querySnapshot.docs;
      filteredUsers = querySnapshot.docs;
    });
  }

  void _updatePage(void noParam) async {
    await getAllUsers();
    filterUsers(_searchController.text);
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredUsers = allUsers;
      });
    } else {
      List<QueryDocumentSnapshot> tmpList = [];
      for (var user in allUsers) {
        var username = user['username'].toString().toLowerCase();
        var email = user['email'].toString().toLowerCase();
        if (username.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase())) {
          tmpList.add(user);
        }
      }
      setState(() {
        filteredUsers = tmpList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search User',
              hintText: 'Search user by email or username',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            onChanged: filterUsers,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: filteredUsers.length,
            itemBuilder: (BuildContext context, int index) {
              return SearchUserInfo(
                email: filteredUsers[index]['email'] as String,
                username: filteredUsers[index]['username'] as String,
                name: filteredUsers[index]['name'] as String,
                tier: filteredUsers[index]['tier'] as String,
                pfp: filteredUsers[index]['pfp'] as String,
                onUpdatePage: _updatePage,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        )
      ],
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
