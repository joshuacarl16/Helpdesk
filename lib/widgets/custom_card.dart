import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helpdesk_ipt/models/topic.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class TopicCardWidget extends StatelessWidget {
  const TopicCardWidget({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: TopicCard(topic: topic),
    );
  }
}

class TopicCard extends StatelessWidget {
  const TopicCard({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select<UserProvider, User>(
      (provider) => provider.currentUser,
    );
    final username = context.select<UserProvider, String>(
      (provider) {
        for (int i = 0; i < provider.userList.length; i++) {
          if (provider.userList.elementAt(i).userId == topic.userId) {
            return provider.userList.elementAt(i).username;
          }
        }
        return 'Deleted User';
      },
    );
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
            topic.helpStatus
                ? Expanded(
                    flex: 1,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        constraints:
                            const BoxConstraints(minHeight: 100, minWidth: 100),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: Center(
                          child: RichText(
                            text: const TextSpan(
                              text: 'SOLVED',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            const Expanded(
              flex: 3,
              child: Icon(
                Icons.account_circle_outlined,
                size: 50,
              ),
            ),
            // currentUser.userId == topic.userId
            //     ? Expanded(
            //         flex: 2,
            //         child: Checkbox(
            //           value: topic.helpStatus,
            //           onChanged: (value) {
            //             context
            //                 .read<TopicProvider>()
            //                 .toggleHelpstatus(topic);

            //             final snackBar = SnackBar(
            //               content: Text(topic.helpStatus
            //                   ? 'Task completed'
            //                   : 'Task marked incomplete'),
            //               backgroundColor: (Colors.black),
            //             );
            //             ScaffoldMessenger.of(context)
            //                 .showSnackBar(snackBar);
            //           },
            //         ),
            //       )
            //     : const SizedBox(
            //         width: 50,
            //       ),
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
                            topic.topicName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              if (currentUser.userId == topic.userId) {
                                // context
                                //     .read<TopicProvider>()
                                //     .toggleHelpstatus(topic);
                              }
                            },
                            child: topic.helpStatus
                                ? Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : const Icon(Icons.check),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        badges.Badge(
                          badgeContent: Text(
                            '${topic.numberOfComments}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          badgeStyle: badges.BadgeStyle(
                              badgeColor: Theme.of(context).primaryColor),
                          child: const Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.comment,
                              color: Colors.black,
                            ),
                          ),
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
                                color: Theme.of(context).primaryColor),
                          ),
                          const TextSpan(
                            text: ' on ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: DateFormat('MM-dd-yyyy HH:mm')
                                .format(topic.dateCreated),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    topic.content.isNotEmpty
                        ? Text(
                            overflow: TextOverflow.ellipsis,
                            topic.content,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 19, 19, 19)),
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
