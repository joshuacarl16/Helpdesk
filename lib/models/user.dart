import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String userId;
  final String username;
  final String password;
  final String firstName;
  final String lastName;

  User({
    required this.userId,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}

Future<User> fetchUsername(String username) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/users/$username'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final user = User.fromJson(data);
    return user;
  } else {
    throw Exception('Failed to fetch users');
  }
}

Future<bool> registerUser(String userId, String username, String password,
    String firstName, String lastName) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/register/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userId': userId,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    }),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}
