import 'dart:js';

import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/login_page.dart';
import 'package:helpdesk_ipt/provider/provider.dart';
import 'package:helpdesk_ipt/widgets/add_category.dart';
import 'package:helpdesk_ipt/widgets/add_topic.dart';
import 'package:helpdesk_ipt/widgets/category_list.dart';
import 'package:helpdesk_ipt/widgets/topic_list.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  final categoryProvider = CategoryProvider();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CategoryProvider>.value(value: categoryProvider),
      ChangeNotifierProvider<TopicProvider>(
          create: (context) => TopicProvider()),
      ChangeNotifierProvider<UserProvider>(
        create: (context) => UserProvider(),
      ),
      ChangeNotifierProvider<CommentProvider>(
        create: (context) => CommentProvider(),
      ),
      ChangeNotifierProvider<ReplyProvider>(
        create: (context) => ReplyProvider(),
      )
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
          '/': (context) => const Login(),
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
