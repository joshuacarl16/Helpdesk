import 'package:uuid/uuid.dart';

class User {
  final String userId;
  String username;
  String password;
  String firstName;
  String lastName;
  String roles;

  User(
      {required this.username,
      required this.password,
      required this.firstName,
      required this.lastName,
      this.roles = 'user'})
      : userId = const Uuid().v4();

  void promoteToAdmin() {
    roles = 'admin';
  }

  @override
  bool operator ==(covariant User other) => userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}