import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/models/topic.dart';
import 'package:helpdesk_ipt/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'custom_card.dart';

class TopicListWidget extends StatefulWidget {
  const TopicListWidget({Key? key}) : super(key: key);

  @override
  _TopicListWidgetState createState() => _TopicListWidgetState();
}

class _TopicListWidgetState extends State<TopicListWidget> {
  List<Topic> topics = [];

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/topics/'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> topicData = jsonData['topics'];

      setState(() {
        topics =
            topicData.map((topicJson) => Topic.fromJson(topicJson)).toList();
      });
    } else {
      throw Exception('Failed to fetch topics');
    }
  }

  @override
  Widget build(BuildContext context) {
    final topicList = topics;

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
