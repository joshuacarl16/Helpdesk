import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/provider/provider.dart';
import 'package:helpdesk_ipt/signup_page.dart';
import 'package:helpdesk_ipt/widgets/add_category.dart';
import 'package:helpdesk_ipt/widgets/add_topic.dart';
import 'package:helpdesk_ipt/widgets/category_list.dart';
import 'package:helpdesk_ipt/widgets/topic_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  final categoryProvider = CategoryProvider();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CategoryProvider>.value(value: categoryProvider),
      ChangeNotifierProvider<TopicProvider>(
          create: (context) => TopicProvider()),
      ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider<TopicProvider>(
          create: (context) => TopicProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginForm(),
          '/home': (context) => const HomePage(
                username: '',
              ),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white12,
        backgroundColor: Colors.white12,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Welcome ${widget.username}',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding:
                EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 10),
            child: SizedBox(
              height: 30,
              width: double.infinity,
              child: CategoryListWidget(),
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: TopicListWidget(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.note_add_outlined),
                      title: const Text('Add Topic'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddTopicDialog()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.category_outlined),
                      title: const Text('Add Category'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AddCategoryDialog()));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<http.Response> login(String username, String password) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/token/'),
    body: {
      'username': username,
      'password': password,
    },
  );
  return response;
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  void submitLoginForm() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final response = await login(username, password);
    if (response.statusCode == 200) {
      // Login successful, save the token and navigate to the home screen
      final token = json.decode(response.body)['access'];
      await SecureStorage.saveToken(token);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(username: _usernameController.text)),
      );
    } else {
      // Login failed, display an error message
      final error = json.decode(response.body)['detail'];
      setState(() {
        _errorMessage = error;
      });
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
                    onPressed: submitLoginForm),
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
                        MaterialPageRoute(builder: (context) => RegisterPage()),
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

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }
}
