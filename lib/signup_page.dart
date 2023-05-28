import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Declare text editing controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  Future<void> _registerUser() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String email = _emailController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;

    if (password != confirmPassword) {
      print("Passwords do not match.");
      return;
    }

    var response =
        await http.post(Uri.parse('http://127.0.0.1:8000/register/'), body: {
      'username': username,
      'password': password,
      'password2': confirmPassword,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    });

    var responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(responseBody);
    } else {
      print(responseBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _firstNameController, // Add this
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
            TextField(
              controller: _lastNameController, // Add this
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            ElevatedButton(
              child: Text('Register'),
              onPressed: _registerUser,
            ),
          ],
        ),
      ),
    );
  }
}
