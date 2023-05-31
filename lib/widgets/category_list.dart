import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/models/category.dart';
import 'package:helpdesk_ipt/provider/provider.dart';
import 'package:provider/provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final categoryList = categoryProvider.categoryList;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  categoryProvider.setAllCategory();
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
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
      },
    );
  }
}
