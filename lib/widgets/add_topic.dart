import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/topic.dart';
import '../provider/provider.dart';
import 'package:http/http.dart' as http;

Future<dynamic> displayAddTopicDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AddTopicDialog();
    },
  );
}

class AddTopicDialog extends StatefulWidget {
  const AddTopicDialog({Key? key}) : super(key: key);

  @override
  State<AddTopicDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddTopicDialog> {
  late final TextEditingController _topicNameController;
  late final TextEditingController _topicContentController;
  late final TextEditingController _topicCategoryController;

  @override
  void initState() {
    _topicNameController = TextEditingController();
    _topicContentController = TextEditingController();
    _topicCategoryController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _topicNameController.dispose();
    _topicContentController.dispose();
    _topicCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uProvider = Provider.of<UserProvider>(context);
    final cProvider = Provider.of<CategoryProvider>(context);
    final currentUser = uProvider.currentUser;

    return AlertDialog(
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Text(
            'Add new topic',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLines: 1,
            controller: _topicNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Topic Title',
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            maxLines: 1,
            controller: _topicCategoryController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category',
            ),
          ),
          TextField(
            maxLines: 3,
            controller: _topicContentController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Problem Description',
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                final topicName = _topicNameController.text;
                final topicContent = _topicContentController.text;
                final topicCategoryName = _topicCategoryController.text;

                // String topicId = '';

                // for (int i = 0; i < cProvider.categoryList.length; i++) {
                //   if (_topicCategoryController.text ==
                //       cProvider.categoryList[i].name) {
                //     final categoryId = cProvider.categoryList[i].id;
                //     topicId = categoryId != null ? categoryId.toString() : '';
                //     break;
                //   }
                // }

                if (topicName.isNotEmpty) {
                  final topic = Topic(
                    categoryName: topicCategoryName,
                    topicName: topicName,
                    userId: currentUser.userId,
                    content: topicContent,
                    dateCreated: DateTime.now(),
                    numberOfComments: null,
                  );

                  final response = await http.post(
                    Uri.parse('http://127.0.0.1:8000/add_topic/'),
                    body: json.encode(topic.toJson()),
                    headers: {'Content-Type': 'application/json'},
                  );
                  print('Response status code: ${response.statusCode}');
                  print('Response body: ${response.body}');
                  if (response.statusCode == 201) {
                    // Topic saved successfully
                    final jsonData = json.decode(response.body);
                    final newTopic = Topic.fromJson(jsonData);
                    context.read<TopicProvider>().add(newTopic);
                    Navigator.of(context).pop();
                  } else {
                    throw Exception('Failed to save topic');
                  }
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
