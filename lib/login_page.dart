import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/main.dart';
import 'package:helpdesk_ipt/models/user.dart';
import 'package:helpdesk_ipt/provider/provider.dart';
import 'package:helpdesk_ipt/signup_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/login/'),
      body: {
        'username': username,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      // Login successful
      final responseData = json.decode(response.body);
      final token = responseData['token'];
      print('Login successful');
      return true;
    } else {
      // Login failed
      final data = jsonDecode(response.body);
      print('Login failed: ${data['status']}');
      print(data);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.live_help_outlined,
                size: 200,
                color: Colors.yellow[300],
              ),

              const SizedBox(height: 30),

              // username textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      controller: _usernameController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Username',
                          hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 117, vertical: 20),
                    ),
                    icon: const Icon(Icons.login),
                    label: const Text('LOG IN',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      final bool istrue = await login(
                          _usernameController.text, _passwordController.text);
                      if (istrue) {
                        final User users =
                            await fetchUsername(_usernameController.text);
                        print(users.userId);
                        context.read<UserProvider>().fetchUsers();
                        context.read<UserProvider>().setUser(users);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(username: _usernameController.text)),
                        );
                      }
                    }),
              ),
              const SizedBox(height: 25),

              const Text('Forgot password?',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not registered?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      ' Sign up now',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              if (_errorMessage.isNotEmpty)
                Card(
                  margin: const EdgeInsets.only(top: 24),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
