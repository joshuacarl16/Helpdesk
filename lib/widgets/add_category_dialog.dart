import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/models/category.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';

Future<dynamic> displayAddCategoryDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<CategoryProvider>(
            create: (context) => CategoryProvider(),
          ),
          ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider(),
          ),
        ],
        child: const AddCategoryDialog(),
      );
    },
  );
}

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({Key? key}) : super(key: key);

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
    final uProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = uProvider.currentUser;

    return AlertDialog(
      title: const Text(
        'Add new category',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLines: 1,
            controller: _categoryNameController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Category Name',
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                final name = _categoryNameController.text;

                if (name.isNotEmpty) {
                  final category = Category(
                    categoryName: name,
                    id: null,
                  );
                  Provider.of<CategoryProvider>(context, listen: false)
                      .add(category);
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
