import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uuid/uuid.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _errorMessage = '';

  void register(String userId, String username, String password,
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
        'firstname': firstName,
        'lastname': lastName,
      }),
    );
    var responseBody = jsonDecode(response.body);

    if (response.statusCode == 201) {
      // Updated status code check to 201
      print(responseBody);
      Navigator.pop(context);
    } else {
      setState(() {
        print(responseBody);
        _errorMessage = 'Failed to register user';
      });
    }
  }

  //   var response =
  //       await http.post(Uri.parse('http://127.0.0.1:8000/register/'), body: {
  //     'username': username,
  //     'password': password,
  //     'password2': confirmPassword,
  //     'email': email,
  //     'first_name': firstName,
  //     'last_name': lastName,
  //   });

  //   var responseBody = jsonDecode(response.body);

  //   if (response.statusCode == 200) {
  //     print(responseBody);
  //   } else {
  //     print(responseBody);
  //   }
  // }

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
            // TextField(
            //   controller: _emailController,
            //   decoration: InputDecoration(
            //     labelText: 'Email',
            //   ),
            // ),
            ElevatedButton(
                child: Text('Register'),
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  final uuid = Uuid();
                  final userId = uuid.v4();
                  register(
                      userId,
                      _usernameController.text,
                      _passwordController.text,
                      _firstNameController.text,
                      _lastNameController.text);
                }
                // },
                ),
          ],
        ),
      ),
    );
  }
}
