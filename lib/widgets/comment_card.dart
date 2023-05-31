import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_ipt/models/comment.dart';
import 'package:helpdesk_ipt/models/reply.dart';
// import 'package:helpdesk_ipt/widgets/reply_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/user.dart';
import '../provider/provider.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReplyProvider>();
    final currentUser = context.select<UserProvider, User?>(
      (provider) => provider.user,
    );

    final user = context.select<UserProvider, User?>((provider) {
      for (int i = 0; i < provider.usersList.length; i++) {
        if (provider.usersList.elementAt(i)?.userId == comment.userId) {
          return provider.usersList.elementAt(i);
        }
      }
      return null;
    });

    TextEditingController controller = TextEditingController();
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: PhysicalModel(
        color: Colors.white,
        shadowColor: const Color(0xFF1B0130),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(
                      Icons.account_box_outlined,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          comment.content.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    comment.content,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 19, 19, 19)),
                                  ),
                                )
                              : const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              comment.showReply
                  ? Column(
                      children: [
                        // provider.replyList.isNotEmpty
                        //     ? ReplyListWidget(comment: comment)
                        // : const SizedBox(),
                        const Divider(
                          color: Color.fromARGB(255, 200, 199, 199),
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextField(
                              textAlign: TextAlign.start,
                              autofocus: false,
                              controller: controller,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                labelText: "Reply",
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              // Container(
              //   margin: const EdgeInsets.symmetric(vertical: 5),
              //   child: Row(
              //     children: [
              //       comment.showReply
              //           ? Expanded(
              //               flex: 5,
              //               child: Padding(
              //                 padding:
              //                     const EdgeInsets.symmetric(horizontal: 12),
              //                 child: ElevatedButton(
              //                   style: ElevatedButton.styleFrom(
              //                     elevation: 5,
              //                     backgroundColor:
              //                         user?.role == 'admin'
              //                       ? Colors.blue: Theme.of(context).primaryColor,
              //                   ),
              //                   onPressed: () {
              //                     if (controller.text.isNotEmpty) {
              //                       final replyId = const Uuid().v4();
              //                       final reply = Reply(
              //                         replyId: replyId,
              //                         commentId: comment.commentId,
              //                         content: controller.text,
              //                         userId: currentUser!.userId,
              //                         username: currentUser.username,
              //                         dateCreated: DateTime.now().toString(),
              //                       );
              //                       Map<String, String> headers = {
              //                         'Content-type': 'application/json',
              //                         'Accept': 'application/json',
              //                       };

              //                       String url = '${Env.urlPrefix}/reply/add';
              //                       http.post(Uri.parse(url),
              //                           headers: headers,
              //                           body: jsonEncode(reply.toJson()));
              //                       context
              //                           .read<TopicProvider>()
              //                           .fetchTopicList();
              //                       context
              //                           .read<ReplyProvider>()
              //                           .fetchReplyList();
              //                     }
              //                   },
              //                   child: const SizedBox(
              //                     height: 30,
              //                     width: double.infinity,
              //                     child: Center(
              //                       child: Text(
              //                         "Reply",
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             fontWeight: FontWeight.bold),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             )
              //           : const SizedBox(),
              //       Expanded(
              //         flex: 5,
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 12),
              //           child: ElevatedButton(
              //             onPressed: () {
              //               context
              //                   .read<CommentProvider>()
              //                   .toggleReplies(comment);
              //             },
              //             style: ElevatedButton.styleFrom(
              //               elevation: 5,
              //               backgroundColor: user?.role == 'admin'
              //                       ? Colors.blue: Theme.of(context).primaryColor,
              //             ),
              //             child: SizedBox(
              //               height: 30,
              //               width: double.infinity,
              //               child: Center(
              //                 child: Text(
              //                   comment.showReply
              //                       ? "Hide Replies"
              //                       : "Show Replies",
              //                   style: const TextStyle(
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.bold),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
