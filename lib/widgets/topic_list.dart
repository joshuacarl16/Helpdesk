import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helpdesk_ipt/models/category.dart';
import 'package:helpdesk_ipt/models/topic.dart';
import 'package:helpdesk_ipt/provider/provider.dart';
import 'package:provider/provider.dart';
import 'topic_card.dart';

class TopicListWidget extends StatefulWidget {
  const TopicListWidget({Key? key}) : super(key: key);

  @override
  _TopicListWidgetState createState() => _TopicListWidgetState();
}

class _TopicListWidgetState extends State<TopicListWidget> {
  @override
  void initState() {
    super.initState();
    context.read<TopicProvider>().fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = context.watch<CategoryProvider>().currentCategory;

    List<Topic> filteredTopics;
    if (currentCategory.categoryId == 'All') {
      filteredTopics = context.watch<TopicProvider>().topicList;
    } else {
      filteredTopics = context
          .watch<TopicProvider>()
          .getFilteredTopics(currentCategory.categoryId);
    }

    return filteredTopics.isEmpty
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
            itemCount: filteredTopics.length,
            itemBuilder: (context, index) {
              final topic = filteredTopics[index];
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                secondaryActions: [
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      _deleteTopic(topic);
                    },
                  ),
                ],
                child: TopicCardWidget(topic: topic),
              );
            },
          );
  }

  void _deleteTopic(Topic topic) {
    final topicProvider = context.read<TopicProvider>();
    topicProvider.deleteTopic(topic);
  }
}
