import 'package:flutter_guid/flutter_guid.dart';

class User {
  final Guid userId;
  final String email;
  final String username;

  User({required this.userId, required this.email, required this.username});
}
