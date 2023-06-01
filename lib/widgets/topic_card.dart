import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/models/topic.dart';
import 'package:helpdesk_ipt/widgets/topic_details.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class TopicCardWidget extends StatelessWidget {
  const TopicCardWidget({
    Key? key,
    required this.topic,
  }) : super(key: key);

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
          onTap: () async {
            final commentProvider = context.read<CommentProvider>();
            await commentProvider.fetchComments();

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicDetails(topic: topic),
                ));
          },
          child: TopicCard(topic: topic)),
    );
  }
}

class TopicCard extends StatelessWidget {
  const TopicCard({
    Key? key,
    required this.topic,
  }) : super(key: key);

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final username = context.select<UserProvider, String>(
      (provider) {
        for (int i = 0; i < provider.usersList.length; i++) {
          if (provider.usersList.elementAt(i)!.userId == topic.userId) {
            return provider.usersList.elementAt(i)!.username;
          }
        }
        return 'Unknown User';
      },
    );
    final cProvider = Provider.of<CategoryProvider>(context, listen: false);
    final categoryName = context.select<CategoryProvider, String>((provider) {
      for (int i = 0; i < cProvider.categoryList.length; i++) {
        if (topic.categoryId == cProvider.categoryList[i].categoryId) {
          return provider.categoryList.elementAt(i).categoryName;
        }
      }
      return '';
    });
    final createdDateTime = DateTime.parse(topic.created);
    final formattedDateTime =
        DateFormat('MM-dd-yyyy HH:mm').format(createdDateTime);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 100),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.question_answer,
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            topic.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'by ',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: username,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const TextSpan(
                            text: ' on ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: formattedDateTime,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Category: ${categoryName.toUpperCase()}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    topic.description.isNotEmpty
                        ? Text(
                            overflow: TextOverflow.ellipsis,
                            topic.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 19, 19, 19),
                            ),
                          )
                        : const SizedBox(height: 12),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
