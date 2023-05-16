import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/models/category.dart';
import 'package:helpdesk_ipt/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({Key? key}) : super(key: key);

  @override
  _CategoryListWidgetState createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/categories/'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> topicData = jsonData['categories'];

      setState(() {
        categories =
            topicData.map((topicJson) => Category.fromJson(topicJson)).toList();
      });
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.read<CategoryProvider>();
    final categoryList = categories;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              categoryProvider.setActiveCategoryFalse();
            },
            child: Container(
              width: 100,
              height: 30,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'All',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          categoryList.isEmpty
              ? const SizedBox(
                  width: 1,
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      // padding: const EdgeInsets.all(16),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 15,
                      ),
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        final category = categoryList[index];
                        return GestureDetector(
                          onTap: () {
                            categoryProvider.setCurrentCategory(category);
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              category.categoryName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
