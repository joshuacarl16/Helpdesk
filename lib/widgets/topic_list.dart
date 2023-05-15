import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/provider/provider.dart';
import 'package:provider/provider.dart';

import 'custom_card.dart';

class TopicListWidget extends StatelessWidget {
  const TopicListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cProvider = context.watch<CategoryProvider>();
    final provider = context.watch<TopicProvider>();
    final topicList = cProvider.activeCategory
        ? provider.topicList
            .where((e) => cProvider.currentCategory.name == e.categoryName)
            .toList()
        : provider.topicList;

    return topicList.isEmpty
        ? const Center(
            child: Text(
              'No entries',
              style: TextStyle(fontSize: 20),
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => Container(height: 8),
            itemCount: topicList.length,
            itemBuilder: (context, index) {
              final topic = topicList[index];
              return TopicCardWidget(topic: topic);
            },
          );
  }
}
