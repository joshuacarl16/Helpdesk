import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/category.dart';
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
  Category? selectedCategory;
  String topicCategory = '';

  @override
  void initState() {
    _topicNameController = TextEditingController();
    _topicContentController = TextEditingController();
    _topicCategoryController = TextEditingController();
    selectedCategory = null;
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
    final currentUser = uProvider.user;

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
          DropdownButtonFormField<Category>(
            value: selectedCategory,
            onChanged: (Category? newValue) {
              setState(() {
                selectedCategory = newValue;
                topicCategory = newValue?.categoryName ?? '';
              });
            },
            items: cProvider.categoryList.map<DropdownMenuItem<Category>>(
              (Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.categoryName),
                );
              },
            ).toList(),
            decoration: InputDecoration(
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
                final topicCategory = _topicCategoryController.text;
                String categoryId = "";

                for (int i = 0; i < cProvider.categoryList.length; i++) {
                  if (selectedCategory == cProvider.categoryList[i]) {
                    categoryId = cProvider.categoryList[i].categoryId;
                  }
                }

                if (topicName.isNotEmpty && topicContent.isNotEmpty) {
                  final topicId = Uuid().v4();
                  final topic = Topic(
                    userId: currentUser!.userId,
                    topicId: topicId,
                    title: topicName,
                    description: topicContent,
                    categoryId: categoryId,
                    created: DateTime.now().toIso8601String(),
                    categoryName: topicCategory,
                  );

                  final response = await http.post(
                    Uri.parse('http://127.0.0.1:8000/add_topic/'),
                    body: jsonEncode(topic.toJson()),
                    headers: {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json'
                    },
                  );
                  context.read<TopicProvider>().addTopic(topic);
                  print('Response status code: ${response.statusCode}');
                  print('Response body: ${response.body}');
                  Navigator.of(context).pop();
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
