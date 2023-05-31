import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/models/category.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../provider/provider.dart';

Future<dynamic> displayAddCategoryDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AddCategoryDialog();
    },
  );
}

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late final TextEditingController _categoryNameController;

  @override
  void initState() {
    _categoryNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cProvider = Provider.of<CategoryProvider>(context, listen: false);
    final uProvider = Provider.of<UserProvider>(context);
    final currentUser = uProvider.user;

    return AlertDialog(
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Text(
            'Add new category',
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
            controller: _categoryNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category Name',
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                final categoryName = _categoryNameController.text;

                if (categoryName.isNotEmpty) {
                  final categoryId = Uuid().v4();
                  final category = Category(
                    userId: currentUser!.userId,
                    categoryId: categoryId,
                    categoryName: categoryName,
                  );
                  final response = await http.post(
                    Uri.parse('http://127.0.0.1:8000/add_category/'),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode(category.toJson()),
                  );
                  Navigator.of(context).pop();
                  context.read<CategoryProvider>().fetchCategories();
                  print(response.body);
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
